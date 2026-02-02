import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/ip_location_service.dart';
import '../../data/repositories/prayer_time_repository.dart';

part 'prayer_time_event.dart';
part 'prayer_time_state.dart';

class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  final PrayerTimeRepository repository;
  final LocationService locationService;
  final IpLocationService ipLocationService;

  PrayerTimeBloc({
    required this.repository,
    required this.locationService,
    required this.ipLocationService,
  }) : super(PrayerTimeInitial()) {
    on<LoadPrayerTimes>(_onLoadPrayerTimes);
    on<RequestLocation>(_onRequestLocation);
    on<UpdatePrayerSettings>(_onUpdatePrayerSettings);
  }

  Future<void> _onLoadPrayerTimes(
    LoadPrayerTimes event,
    Emitter<PrayerTimeState> emit,
  ) async {
    // Determine location and method automatically on load
    await _determineLocationAndFetch(emit);
  }

  Future<void> _onRequestLocation(
    RequestLocation event,
    Emitter<PrayerTimeState> emit,
  ) async {
    // Same logic, potentially forcing GPS more aggressively, but for now reuse shared logic
    await _determineLocationAndFetch(emit);
  }

  Future<void> _determineLocationAndFetch(Emitter<PrayerTimeState> emit) async {
    emit(PrayerTimeLoading());
    try {
      double? lat;
      double? long;
      String? countryCode;
      bool usedIp = false;

      // 1. Try GPS
      try {
        final position = await locationService.determinePosition();
        lat = position.latitude;
        long = position.longitude;
      } catch (e) {
        // GPS failed or denied, try IP
        usedIp = true;
      }

      // 2. Try IP if GPS failed
      if (lat == null || long == null) {
        try {
          final ipLocation = await ipLocationService.getLocation();
          lat = ipLocation['lat'];
          long = ipLocation['lon'];
          countryCode = ipLocation['countryCode'];
        } catch (e) {
          // Both failed, fallback to Mecca (handled by repo if lat/long null)
        }
      }

      // 3. If we have GPS coords but no country code, reverse geocode
      if (!usedIp && lat != null && long != null && countryCode == null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            lat,
            long,
          );
          if (placemarks.isNotEmpty) {
            countryCode = placemarks.first.isoCountryCode;
          }
        } catch (_) {
          // Ignore reverse geocoding errors
        }
      }

      // 4. Determine Method
      int? method;
      if (countryCode != null) {
        method = repository.getAutoDetectedMethod(countryCode);
      }

      // 5. Fetch
      final timings = await repository.getPrayerTimes(
        lat: lat,
        long: long,
        method: method,
        // We leave school as null to let repository use default/pref,
        // or we could add auto-detect logic for school too if needed.
        // Requirement says "Default madhab is Shafi", which is school=0 (Standard).
        // Repo defaults to 0 if not set.
      );

      _emitLoadedState(emit, timings);
    } catch (e) {
      // If everything fails (network for API), return error
      emit(PrayerTimeError(e.toString()));
    }
  }

  Future<void> _onUpdatePrayerSettings(
    UpdatePrayerSettings event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(PrayerTimeLoading());
    try {
      await repository.setCalculationMethod(event.calculationMethod);
      await repository.setJuristicMethod(event.juristicMethod);

      // We explicitly fetch with defaults (or cached preferences inside repo)
      // This allows manual override to stick until next auto-detection
      // OR we could call _determineLocationAndFetch again?
      // User asked for "Automatic" without precision setting, so maybe they removed settings dialog?
      // Assuming this event might still be used if settings exist.
      // If we want FULL automatic, we might just re-run auto-detection which overrides method?
      // But usually manual setting should override auto-detect for that session.
      // Let's stick to simple fetch which uses the newly saved prefs.

      final timings = await repository.getPrayerTimes();
      _emitLoadedState(emit, timings);
    } catch (e) {
      emit(PrayerTimeError(e.toString()));
    }
  }

  void _emitLoadedState(
    Emitter<PrayerTimeState> emit,
    Map<String, dynamic> timings,
  ) {
    final nextPrayer = _calculateNextPrayer(timings);
    emit(
      PrayerTimeLoaded(
        nextPrayerName: nextPrayer['name'],
        nextPrayerTime: nextPrayer['time'],
        timeRemaining: nextPrayer['remaining'],
      ),
    );
  }

  Map<String, dynamic> _calculateNextPrayer(Map<String, dynamic> timings) {
    final now = DateTime.now();

    // Map of prayer names (English keys from API) to Arabic display names
    // This could also be handled via Localization, but for simplicity here:
    final prayerNames = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق', // Optional to show
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    String? bestNextName;
    String? bestNextTime;
    Duration? minDiff;

    // Ordered list of keys we care about
    final keys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (final key in keys) {
      final timeStr = timings[key]; // "HH:mm"
      if (timeStr == null) continue;

      // Parse time
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      var prayerDate = DateTime(now.year, now.month, now.day, hour, minute);

      if (prayerDate.isBefore(now)) {
        // If it's already passed today, it might be the "next" if we consider tomorrow's Fajr
        // But for this loop, we look for upcoming today.
        // Tomorrow's Fajr logic needs special handling if *all* today are passed.
        continue;
      }

      final diff = prayerDate.difference(now);

      if (minDiff == null || diff < minDiff) {
        minDiff = diff;
        bestNextName = prayerNames[key] ?? key;
        bestNextTime = timeStr;
      }
    }

    // If no prayer found left today, assume tomorrow's Fajr
    if (bestNextName == null) {
      final fajrTime = timings['Fajr'];
      final parts = fajrTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final tomorrow = now.add(const Duration(days: 1));
      final prayerDate = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        hour,
        minute,
      );

      minDiff = prayerDate.difference(now);
      bestNextName = prayerNames['Fajr'];
      bestNextTime = fajrTime;
    }

    return {'name': bestNextName, 'time': bestNextTime, 'remaining': minDiff};
  }
}

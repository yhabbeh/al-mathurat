import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PrayerTimeRepository {
  static const String _baseUrlCity = 'http://api.aladhan.com/v1/timingsByCity';
  static const String _baseUrlCoords = 'http://api.aladhan.com/v1/timings';
  static const String _cacheKey = 'prayer_times_cache';
  static const String _cacheDateKey = 'prayer_times_date';
  static const String _methodKey = 'prayer_method';
  static const String _schoolKey = 'prayer_school';

  // Methods:
  // 1: Karachi, 2: ISNA, 3: MWL, 4: Makkah (Default), 5: Egypt
  Future<int> getCalculationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_methodKey) ?? 4;
  }

  Future<void> setCalculationMethod(int method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_methodKey, method);
  }

  // School: 0: Standard (Default), 1: Hanafi
  Future<int> getJuristicMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_schoolKey) ?? 0;
  }

  Future<void> setJuristicMethod(int school) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_schoolKey, school);
  }

  /// Automatically checks the region based on country code and returns the appropriate method.
  /// Saudi Arabia & Gulf countries -> Umm Al-Qura (method=4)
  /// North America -> ISNA (method=2)
  /// Europe -> Muslim World League (method=3)
  /// Egypt & North Africa -> Egyptian Authority (method=5)
  /// South Asia -> Karachi (method=1)
  /// Southeast Asia -> Muslim World League (method=3)
  /// Any unknown region -> Muslim World League (method=3)
  int getAutoDetectedMethod(String countryCode) {
    const gulfCountries = ['SA', 'AE', 'KW', 'QA', 'BH', 'OM'];
    const northAmerica = ['US', 'CA'];
    // Simplified Europe list for now, or just default to MWL
    const egyptNorthAfrica = ['EG', 'DZ', 'TN', 'LY', 'MA', 'SD'];
    const southAsia = ['PK', 'IN', 'BD', 'AF'];
    const southEastAsia = ['ID', 'MY', 'SG', 'BN', 'TH', 'PH'];

    if (gulfCountries.contains(countryCode)) return 4;
    if (northAmerica.contains(countryCode)) return 2;
    if (egyptNorthAfrica.contains(countryCode)) return 5;
    if (southAsia.contains(countryCode)) return 1;
    if (southEastAsia.contains(countryCode)) return 3;

    // Default for Europe and others
    return 3;
  }

  Future<Map<String, dynamic>> getPrayerTimes({
    double? lat,
    double? long,
    int? method,
    int? school,
    DateTime? date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final targetDate = date ?? today;

    final todayStr = DateFormat('dd-MM-yyyy').format(today);
    final targetDateStr = DateFormat('dd-MM-yyyy').format(targetDate);
    final isToday = todayStr == targetDateStr;

    // If method/school provided (e.g. from auto-detect), use it.
    // Otherwise fallback to stored preferences.
    final usedMethod = method ?? await getCalculationMethod();
    final usedSchool = school ?? await getJuristicMethod();

    // Check cache first (simple cache invalidation by date)
    // Only check cache if requesting for today
    final cacheKeyCombined = '${_cacheKey}_${usedMethod}_$usedSchool';

    if (isToday) {
      final cachedDate = prefs.getString(_cacheDateKey);
      final cachedData = prefs.getString(cacheKeyCombined);

      if (cachedDate == todayStr && cachedData != null) {
        try {
          return json.decode(cachedData) as Map<String, dynamic>;
        } catch (e) {
          // Cache corrupted
        }
      }
    }

    Uri url;
    if (lat != null && long != null) {
      url = Uri.parse(
        '$_baseUrlCoords/$targetDateStr?latitude=$lat&longitude=$long&method=$usedMethod&school=$usedSchool',
      );
    } else {
      // Default fallback
      url = Uri.parse(
        '$_baseUrlCity/$targetDateStr?city=Mecca&country=Saudi Arabia&method=$usedMethod&school=$usedSchool',
      );
    }

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        // Cache data only if it is for today
        if (isToday) {
          await prefs.setString(_cacheDateKey, todayStr);
          await prefs.setString(cacheKeyCombined, json.encode(timings));
        }

        return timings;
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

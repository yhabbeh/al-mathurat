import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/prayer_time_bloc.dart';

class PrayerSettingsDialog extends StatefulWidget {
  const PrayerSettingsDialog({super.key});

  @override
  State<PrayerSettingsDialog> createState() => _PrayerSettingsDialogState();
}

class _PrayerSettingsDialogState extends State<PrayerSettingsDialog> {
  int _selectedMethod = 4; // Default Makkah
  int _selectedSchool = 0; // Default Standard

  @override
  void initState() {
    super.initState();
    // ideally we fetch current settings from repo to init these
    // For MVP, handling locally or we can fire an event to get settings
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Precision Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Calculation Method Dropdown
              const Text(
                'Calculation Method',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedMethod,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 4,
                    child: Text('Umm Al-Qura (Makkah)'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('Egyptian General Authority'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('SNA (North America)'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Muslim World League'),
                  ),
                  DropdownMenuItem(value: 1, child: Text('Karachi')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedMethod = val);
                },
              ),
              const SizedBox(height: 16),

              // Juristic Method Dropdown
              const Text(
                'Asr Calculation',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedSchool,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Standard (Shafi, Maliki, Hanbali)'),
                  ),
                  DropdownMenuItem(value: 1, child: Text('Hanafi')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSchool = val);
                },
              ),
              const SizedBox(height: 24),

              // Update Location Button (secondary)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<PrayerTimeBloc>().add(const RequestLocation());
                },
                icon: const Icon(Icons.my_location),
                label: const Text('Detect GPS Location'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  context.read<PrayerTimeBloc>().add(
                    UpdatePrayerSettings(
                      calculationMethod: _selectedMethod,
                      juristicMethod: _selectedSchool,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9333EA), // Purple
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

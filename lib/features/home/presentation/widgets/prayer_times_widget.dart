import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prayer_time_bloc.dart';

class PrayerTimesWidget extends StatelessWidget {
  const PrayerTimesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrayerTimeBloc, PrayerTimeState>(
      listenWhen: (previous, current) {
        if (current is PrayerTimeLoaded &&
            current.scheduledNotificationsCount != null) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is PrayerTimeLoaded &&
            state.scheduledNotificationsCount != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم جدولة ${state.scheduledNotificationsCount} إشعار للصلوات القادمة',
              ),
              backgroundColor: const Color(0xFF9333EA),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<PrayerTimeBloc, PrayerTimeState>(
        builder: (context, state) {
          String prayerName = '';
          String prayerTime = '';

          if (state is PrayerTimeLoaded) {
            prayerName = state.nextPrayerName;
            prayerTime = state.nextPrayerTime;
          } else if (state is PrayerTimeLoading) {
            prayerName = '...';
            prayerTime = '...';
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Color(0xFF9333EA),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'الصلاة القادمة',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notification_add,
                                size: 16,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                context.read<PrayerTimeBloc>().add(
                                  TestNotification(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Notification scheduled in 10 seconds',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prayerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prayerTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9333EA),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

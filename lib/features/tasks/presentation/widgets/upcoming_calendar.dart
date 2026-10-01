import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class UpcomingCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const UpcomingCalendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // أول يوم مسموح في Upcoming هو غدًا.
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    return Container(
      padding: const EdgeInsets.all(
        AppDimensions.spacing12,
      ),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: TableCalendar(
        // لا نسمح بالانتقال أو اختيار أي يوم قبل الغد.
        firstDay: tomorrow,

        lastDay: DateTime(
          2035,
          12,
          31,
        ),

        focusedDay: focusedDay,

        selectedDayPredicate: (day) {
          return isSameDay(
            selectedDay,
            day,
          );
        },

        onDaySelected: (
          selectedDay,
          focusedDay,
        ) {
          // لا نسمح باختيار اليوم أو الأيام السابقة.
          if (selectedDay.isBefore(tomorrow)) {
            return;
          }

          onDaySelected(selectedDay);
          onPageChanged(focusedDay);
        },

        onPageChanged: onPageChanged,

        calendarFormat: CalendarFormat.month,

        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },

        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,

          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textPrimary,
            size: AppDimensions.iconMedium,
          ),

          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary,
            size: AppDimensions.iconMedium,
          ),

          titleTextStyle:
              AppTextStyles.cardTitle,

          headerPadding: EdgeInsets.symmetric(
            vertical: AppDimensions.spacing8,
          ),
        ),

        daysOfWeekStyle:
            const DaysOfWeekStyle(
          weekdayStyle:
              AppTextStyles.small,
          weekendStyle:
              AppTextStyles.small,
        ),

        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,

          defaultTextStyle:
              AppTextStyles.bodySecondary,

          weekendTextStyle:
              AppTextStyles.bodySecondary,

          todayTextStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),

          selectedTextStyle:
              const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),

          todayDecoration:
              const BoxDecoration(
            color: AppColors.blueLight,
            shape: BoxShape.circle,
          ),

          selectedDecoration:
              const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),

          markerDecoration:
              const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),

          markersMaxCount: 1,

          cellMargin: const EdgeInsets.all(
            AppDimensions.spacing4,
          ),
        ),
      ),
    );
  }
}

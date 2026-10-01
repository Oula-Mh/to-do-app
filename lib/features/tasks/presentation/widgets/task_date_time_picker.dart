import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskDateTimePicker extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TaskDateTimePicker({
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateCard(
            date: selectedDate,
            onTap: () => _showDatePicker(context),
          ),
        ),

        const SizedBox(
          width: AppDimensions.spacing12,
        ),

        Expanded(
          child: _TimeCard(
            time: selectedTime,
            onTap: () => _showTimePicker(context),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DATE PICKER
  // ---------------------------------------------------------------------------

  Future<void> _showDatePicker(
    BuildContext context,
  ) async {
    final today = DateUtils.dateOnly(
      DateTime.now(),
    );

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final dialogWidth = screenWidth < 420
        ? screenWidth - 24
        : 380.0;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        DateTime temporaryDate = selectedDate;

        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              backgroundColor:
                  AppColors.surface,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  AppDimensions
                      .largeCardRadius,
                ),
              ),
              child: SizedBox(
                width: dialogWidth,
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    AppDimensions.spacing12,
                  ),
                  child: CalendarDatePicker2(
                    config:
                        CalendarDatePicker2Config(
                      calendarType:
                          CalendarDatePicker2Type
                              .single,

                      firstDate: today,

                      lastDate: DateTime(
                        today.year + 5,
                        12,
                        31,
                      ),

                      currentDate: today,

                      selectedDayHighlightColor:
                          AppColors.primary,

                      selectedDayTextStyle:
                          AppTextStyles.body.copyWith(
                        color:
                            AppColors.white,
                        fontWeight:
                            FontWeight.w600,
                      ),

                      dayTextStyle:
                          AppTextStyles
                              .bodySecondary,

                      weekdayLabelTextStyle:
                          AppTextStyles.small
                              .copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),

                      controlsTextStyle:
                          AppTextStyles.body
                              .copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),

                      dynamicCalendarRows: true,

                      centerAlignModePicker:
                          true,

                      // يجعل اختيار اليوم واضحاً
                      // ويمنع الحاجة لتأكيد إضافي.
                      allowSameValueSelection:
                          true,
                    ),

                    value: [
                      temporaryDate,
                    ],

                    // هذا هو الجزء المهم:
                    // CalendarDatePicker2 يعيد التاريخ
                    // عند الضغط على أي يوم.
                    onValueChanged: (dates) {
                      if (dates.isEmpty) {
                        return;
                      }

                      final date = dates.first;


                      setDialogState(() {
                        temporaryDate =
                            DateUtils.dateOnly(
                          date,
                        );
                      });

                      // نغلق الـ Dialog مباشرة
                      // ونرجع التاريخ المختار.
                      Navigator.of(
                        dialogContext,
                      ).pop(
                        DateUtils.dateOnly(
                          date,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onDateChanged(
        DateUtils.dateOnly(result),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // TIME PICKER
  // ---------------------------------------------------------------------------

  Future<void> _showTimePicker(
    BuildContext context,
  ) async {
    final result =
        await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor:
          Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _TimePickerSheet(
          initialTime: selectedTime,
        );
      },
    );

    if (result != null) {
      onTimeChanged(result);
    }
  }
}

// =============================================================================
// DATE CARD
// =============================================================================

class _DateCard extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PickerCard(
      icon: Icons.calendar_today_rounded,
      title: DateFormat('dd MMM').format(date),
      subtitle: DateFormat('EEEE').format(date),
      onTap: onTap,
    );
  }
}

// =============================================================================
// TIME CARD
// =============================================================================

class _TimeCard extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeCard({
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PickerCard(
      icon: Icons.schedule_rounded,
      title: time.format(context),
      subtitle: 'Reminder time',
      onTap: onTap,
    );
  }
}

// =============================================================================
// SHARED PICKER CARD
// =============================================================================

class _PickerCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PickerCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius:
          BorderRadius.circular(
        AppDimensions.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          AppDimensions.cardRadius,
        ),
        child: Container(
          padding:
              const EdgeInsets.all(
            AppDimensions.spacing12,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              AppDimensions.cardRadius,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width:
                    AppDimensions.iconLarge +
                        AppDimensions.spacing8,
                height:
                    AppDimensions.iconLarge +
                        AppDimensions.spacing8,
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.blueLight,
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size:
                      AppDimensions.iconSmall,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width:
                    AppDimensions.spacing8,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          AppTextStyles.body
                              .copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppDimensions.spacing4,
                    ),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          AppTextStyles.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TIME PICKER SHEET
// =============================================================================

class _TimePickerSheet
    extends StatefulWidget {
  final TimeOfDay initialTime;

  const _TimePickerSheet({
    required this.initialTime,
  });

  @override
  State<_TimePickerSheet>
      createState() =>
          _TimePickerSheetState();
}

class _TimePickerSheetState
    extends State<_TimePickerSheet> {
  late int _hour;
  late int _minute;
  late bool _isPm;

  @override
  void initState() {
    super.initState();

    final hour =
        widget.initialTime.hour;

    _hour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    _minute =
        widget.initialTime.minute;

    _isPm = hour >= 12;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          AppDimensions.spacing20,
          AppDimensions.spacing16,
          AppDimensions.spacing20,
          AppDimensions.spacing20,
        ),
        decoration:
            const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration:
                  BoxDecoration(
                color:
                    AppColors.border,
                borderRadius:
                    BorderRadius.circular(
                  AppDimensions
                      .circularRadius,
                ),
              ),
            ),

            const SizedBox(
              height:
                  AppDimensions.spacing20,
            ),

            Text(
              'Choose time',
              style:
                  AppTextStyles
                      .sectionTitle,
            ),

            const SizedBox(
              height:
                  AppDimensions.spacing24,
            ),

            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  // -----------------------------------------------------------
                  // HOURS
                  // -----------------------------------------------------------

                  _WheelColumn<int>(
                    values:
                        List.generate(
                      12,
                      (index) =>
                          index + 1,
                    ),
                    initialIndex:
                        _hour - 1,
                    looping: true,
                    itemLabel:
                        (value) => value
                            .toString()
                            .padLeft(
                              2,
                              '0',
                            ),
                    onChanged:
                        (value) {
                      _hour = value;
                    },
                  ),

                  const SizedBox(
                    width:
                        AppDimensions
                            .spacing8,
                  ),

                  Text(
                    ':',
                    style:
                        AppTextStyles
                            .title,
                  ),

                  const SizedBox(
                    width:
                        AppDimensions
                            .spacing8,
                  ),

                  // -----------------------------------------------------------
                  // MINUTES
                  // -----------------------------------------------------------

                  _WheelColumn<int>(
                    values:
                        List.generate(
                      60,
                      (index) =>
                          index,
                    ),
                    initialIndex:
                        _minute,
                    looping: true,
                    itemLabel:
                        (value) => value
                            .toString()
                            .padLeft(
                              2,
                              '0',
                            ),
                    onChanged:
                        (value) {
                      _minute = value;
                    },
                  ),

                  const SizedBox(
                    width:
                        AppDimensions
                            .spacing12,
                  ),

                  // -----------------------------------------------------------
                  // AM / PM
                  // -----------------------------------------------------------

                  _WheelColumn<String>(
                    values: const [
                      'AM',
                      'PM',
                    ],
                    initialIndex:
                        _isPm ? 1 : 0,
                    looping: false,
                    itemLabel:
                        (value) => value,
                    onChanged:
                        (value) {
                      setState(() {
                        _isPm =
                            value == 'PM';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height:
                  AppDimensions.spacing24,
            ),

            SizedBox(
              width:
                  double.infinity,
              height:
                  AppDimensions
                      .buttonHeight,
              child: FilledButton(
                onPressed: () {
                  var hour =
                      _hour % 12;

                  if (_isPm) {
                    hour += 12;
                  }

                  Navigator.of(context)
                      .pop(
                    TimeOfDay(
                      hour: hour,
                      minute: _minute,
                    ),
                  );
                },
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      AppColors
                          .textPrimary,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      AppDimensions
                          .cardRadius,
                    ),
                  ),
                ),
                child: const Text(
                  'Done',
                  style:
                      AppTextStyles
                          .button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// WHEEL COLUMN
// =============================================================================

class _WheelColumn<T>
    extends StatelessWidget {
  final List<T> values;
  final int initialIndex;
  final bool looping;

  final String Function(T value)
      itemLabel;

  final ValueChanged<T> onChanged;

  const _WheelColumn({
    required this.values,
    required this.initialIndex,
    required this.looping,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: WheelPicker(
        itemCount:
            values.length,

        initialIndex:
            initialIndex,

        looping:
            looping,

        // ---------------------------------------------------------------------
        // هذا هو التعديل الخاص بتكبير
        // العنصر الموجود في المنتصف.
        // ---------------------------------------------------------------------

        style: const WheelPickerStyle(
          magnification: 1.25,
          squeeze: 1.05,
          diameterRatio: 0.9,
          surroundingOpacity: 0.35,
        ),

        onIndexChanged: (
          index,
          interactionType,
        ) {
          onChanged(
            values[index],
          );
        },

        builder: (
          context,
          index,
        ) {
          final value =
              values[index];

          return Center(
            child: Text(
              itemLabel(value),
              style:
                  AppTextStyles.body
                      .copyWith(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
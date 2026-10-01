import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskImportantSelector
    extends StatelessWidget {
  final bool isImportant;
  final ValueChanged<bool> onChanged;

  const TaskImportantSelector({
    required this.isImportant,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Mark as important',
            style:
                AppTextStyles.body.copyWith(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: isImportant,
          onChanged: onChanged,
          activeTrackColor:
              AppColors.primary,
          inactiveThumbColor:
              AppColors.white,
          inactiveTrackColor:
              AppColors.border,
        ),
      ],
    );
  }
}
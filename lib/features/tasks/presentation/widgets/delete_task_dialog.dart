import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

Future<bool?> showDeleteTaskDialog(
  BuildContext context,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.largeCardRadius,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          AppDimensions.spacing20,
          AppDimensions.spacing20,
          AppDimensions.spacing20,
          AppDimensions.spacing8,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppDimensions.spacing20,
          AppDimensions.spacing8,
          AppDimensions.spacing20,
          AppDimensions.spacing20,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppDimensions.spacing20,
          0,
          AppDimensions.spacing20,
          AppDimensions.spacing20,
        ),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.redLight,
                borderRadius: BorderRadius.circular(
                  AppDimensions.smallRadius,
                ),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
              ),
            ),
            const SizedBox(
              width: AppDimensions.spacing12,
            ),
            const Expanded(
              child: Text(
                AppStrings.deleteTaskTitle,
                style: AppTextStyles.cardTitle,
              ),
            ),
          ],
        ),
        content: const Text(
          AppStrings.deleteTaskMessage,
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.smallRadius,
                ),
              ),
            ),
            child: const Text(
              AppStrings.deleteTask,
            ),
          ),
        ],
      );
    },
  );
}
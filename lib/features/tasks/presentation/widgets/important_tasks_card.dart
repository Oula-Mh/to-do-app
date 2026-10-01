import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ImportantTasksCard extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const ImportantTasksCard({
    required this.count,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.yellowLight,
      borderRadius: BorderRadius.circular(
        AppDimensions.largeCardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        child: Container(
          padding: const EdgeInsets.all(
            AppDimensions.spacing16,
          ),
          decoration: BoxDecoration(
            color: AppColors.yellowLight,
            borderRadius: BorderRadius.circular(
              AppDimensions.largeCardRadius,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.smallRadius,
                  ),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.yellow,
                  size: AppDimensions.iconMedium,
                ),
              ),

              const SizedBox(
                width: AppDimensions.spacing12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Important',
                      style: AppTextStyles.cardTitle,
                    ),

                    const SizedBox(
                      height: AppDimensions.spacing4,
                    ),

                    Text(
                      '$count important ${count == 1 ? 'task' : 'tasks'}',
                      style: AppTextStyles.small,
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
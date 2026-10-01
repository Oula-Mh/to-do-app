import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskOverviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const TaskOverviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(
        AppDimensions.largeCardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            AppDimensions.spacing16,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(
              AppDimensions.largeCardRadius,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.smallRadius,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppDimensions.iconMedium,
                ),
              ),

              const SizedBox(
                width: AppDimensions.spacing12,
              ),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(
                      height: AppDimensions.spacing4,
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.small,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: AppDimensions.spacing8,
              ),

              // Arrow
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
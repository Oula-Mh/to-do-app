import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(
        AppDimensions.largeCardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            AppDimensions.spacing16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: AppDimensions.iconMedium,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.categoryTitle,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing4,
                  ),

                  Text(
                    '$count ${count == 1 ? 'task' : 'tasks'}',
                    style: AppTextStyles.categoryCount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
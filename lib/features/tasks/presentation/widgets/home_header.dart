import 'package:flutter/material.dart';

import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    final String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.bodySecondary,
        ),

        const SizedBox(
          height: AppDimensions.spacing8,
        ),

        const Text(
          'Let’s organize your day.',
          style: AppTextStyles.pageTitle,
        ),

        const SizedBox(
          height: AppDimensions.spacing8,
        ),

        const Text(
          'Stay focused and get things done.',
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }
}
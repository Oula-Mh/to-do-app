import 'package:flutter/material.dart';


import '../constant/app_colors.dart';
import '../constant/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: AppDimensions.buttonHeight,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? null : Icon(icon),
        label: Text(
          label,
          style: AppTextStyles.button,
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.cardRadius,
            ),
          ),
        ),
      ),
    );

    if (!expanded) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
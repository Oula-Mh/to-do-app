import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskFormHeader extends StatelessWidget {
  final bool isEditing;
  final TextEditingController titleController;
  final String? Function(String?)? validator;

  const TaskFormHeader({
    required this.isEditing,
    required this.titleController,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 315,
      child: ClipPath(
        clipper: _TaskHeaderWaveClipper(),
        child: Container(
          width: double.infinity,
          // height: 330,
          color: AppColors.primary,
          padding: EdgeInsets.only(
            top: topPadding + AppDimensions.spacing8,
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              const SizedBox(height: AppDimensions.spacing20),

              Text(
                isEditing ? 'Edit Task' : 'Add Task',
                style: AppTextStyles.pageTitle.copyWith(color: AppColors.white),
              ),

              const SizedBox(height: AppDimensions.spacing8),

              Text(
                isEditing
                    ? 'Make a small change to your task'
                    : 'What would you like to accomplish?',
                style: AppTextStyles.bodySecondary.copyWith(
                  color: AppColors.white.withValues(alpha: 0.82),
                ),
              ),

              const SizedBox(height: AppDimensions.spacing24),

              _TitleField(controller: titleController, validator: validator),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _TitleField({required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textInputAction: TextInputAction.next,
      style: AppTextStyles.body.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: AppColors.white,
      decoration: InputDecoration(
        hintText: 'Task title',
        hintStyle: AppTextStyles.bodySecondary.copyWith(
          color: AppColors.white.withValues(alpha: 0.65),
        ),
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.largeCardRadius),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.30),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.largeCardRadius),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.30),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.largeCardRadius),
          borderSide: const BorderSide(color: AppColors.white, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.largeCardRadius),
          borderSide: BorderSide(color: AppColors.red.withValues(alpha: 0.9)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.largeCardRadius),
          borderSide: const BorderSide(color: AppColors.red, width: 1.3),
        ),
        errorStyle: AppTextStyles.small.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppDimensions.smallRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.smallRadius),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
            size: AppDimensions.iconMedium,
          ),
        ),
      ),
    );
  }
}

class _TaskHeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 42);

    path.quadraticBezierTo(
      size.width * 0.22,
      size.height - 8,
      size.width * 0.50,
      size.height - 34,
    );

    path.quadraticBezierTo(
      size.width * 0.76,
      size.height - 62,
      size.width,
      size.height - 25,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

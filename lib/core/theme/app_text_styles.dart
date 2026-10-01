import 'package:flutter/material.dart';

import '../constant/app_colors.dart';

abstract final class AppTextStyles {
  static const pageTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const bodySecondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const small = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static const button = TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const taskTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const taskDescription = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const taskTime = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const categoryTitle = TextStyle(
    color: AppColors.white,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const categoryCount = TextStyle(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
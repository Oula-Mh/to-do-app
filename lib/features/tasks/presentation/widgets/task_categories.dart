import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';

class TaskCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

abstract final class TaskCategories {
  static const List<TaskCategory> all = [
    TaskCategory(
      id: 'personal',
      title: 'Personal',
      icon: Icons.person_outline_rounded,
      color: AppColors.categoryPersonal,
    ),
    TaskCategory(
      id: 'work',
      title: 'Work',
      icon: Icons.work_outline_rounded,
      color: AppColors.categoryWork,
    ),
    TaskCategory(
      id: 'learning',
      title: 'Learning',
      icon: Icons.menu_book_outlined,
      color: AppColors.categoryLearning,
    ),
    TaskCategory(
      id: 'shopping',
      title: 'Shopping',
      icon: Icons.shopping_bag_outlined,
      color: AppColors.categoryShopping,
    ),
    TaskCategory(
      id: 'visits',
      title: 'Visits',
      icon: Icons.location_on_outlined,
      color: AppColors.categoryVisits,
    ),
  ];

  static TaskCategory byId(String id) {
    return all.firstWhere(
      (category) => category.id == id,
      orElse: () => all.first,
    );
  }
}
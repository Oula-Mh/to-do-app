import 'package:flutter/material.dart';

import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../tasks/domain/entities/task.dart';
import 'category_card.dart';
import 'task_categories.dart';

class CategoriesSection extends StatelessWidget {
  final List<TaskEntity> tasks;
  final ValueChanged<String> onCategoryTap;

  const CategoriesSection({
    required this.tasks,
    required this.onCategoryTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categories = TaskCategories.all;

    final columns =
        ResponsiveUtils.categoryGridColumns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: AppTextStyles.sectionTitle,
        ),

        const SizedBox(
          height: AppDimensions.spacing12,
        ),

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing:
                AppDimensions.spacing12,
            mainAxisSpacing:
                AppDimensions.spacing12,
            mainAxisExtent:
                AppDimensions.categoryCardHeight,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            final count = tasks
                .where(
                  (task) =>
                      task.categoryId ==
                      category.id,
                )
                .length;

            return CategoryCard(
              title: category.title,
              count: count,
              icon: category.icon,
              color: category.color,
              onTap: () {
                onCategoryTap(category.id);
              },
            );
          },
        ),
      ],
    );
  }
}
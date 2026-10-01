import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

import 'task_categories.dart';

class TaskCategorySelector
    extends StatelessWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onChanged;

  const TaskCategorySelector({
    required this.selectedCategoryId,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing:
          AppDimensions.spacing8,
      runSpacing:
          AppDimensions.spacing8,
      children:
          TaskCategories.all.map(
        (category) {
          final isSelected =
              category.id ==
                  selectedCategoryId;

          return InkWell(
            onTap: () {
              onChanged(
                category.id,
              );
            },
            borderRadius:
                BorderRadius.circular(
              AppDimensions
                  .circularRadius,
            ),
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal:
                    AppDimensions
                        .spacing12,
                vertical:
                    AppDimensions
                        .spacing8,
              ),
              decoration:
                  BoxDecoration(
                color: isSelected
                    ? category.color
                        .withValues(
                        alpha: 0.10,
                      )
                    : AppColors
                        .surface,
                borderRadius:
                    BorderRadius.circular(
                  AppDimensions
                      .circularRadius,
                ),
                border:
                    Border.all(
                  color: isSelected
                      ? category.color
                      : AppColors
                          .border,
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width:
                        AppDimensions
                            .spacing12,
                    height:
                        AppDimensions
                            .spacing12,
                    decoration:
                        BoxDecoration(
                      color:
                          category
                              .color,
                      shape:
                          BoxShape
                              .circle,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 8,
                            color:
                                AppColors
                                    .white,
                          )
                        : null,
                  ),

                  const SizedBox(
                    width:
                        AppDimensions
                            .spacing8,
                  ),

                  Text(
                    category.title,
                    style:
                        AppTextStyles
                            .small
                            .copyWith(
                      color: isSelected
                          ? AppColors
                              .textPrimary
                          : AppColors
                              .textSecondary,
                      fontWeight:
                          isSelected
                              ? FontWeight
                                  .w600
                              : FontWeight
                                  .w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

import '../../domain/entities/task.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

import '../widgets/empty_tasks_view.dart';
import '../widgets/error_tasks_view.dart';
import '../widgets/task_categories.dart';
import '../widgets/task_list.dart';

import 'add_edit_task_page.dart';

class CategoryTasksPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final Color categoryColor;

  const CategoryTasksPage({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),

        titleSpacing: 0,

        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: categoryColor,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(
              width: AppDimensions.spacing12,
            ),

            Text(
              categoryName,
              style: AppTextStyles.pageTitle,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state.status == TaskStatus.loading &&
                state.tasks.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state.status == TaskStatus.failure &&
                state.tasks.isEmpty) {
              return ErrorTasksView(
                message:
                    state.errorMessage ?? 'Something went wrong',
              );
            }

            final categoryTasks = _getCategoryTasks(
              state.tasks,
            );

            return RefreshIndicator(
              color: AppColors.primary,

              onRefresh: () async {
                context.read<TaskBloc>().add(
                      const LoadTasks(),
                    );
              },

              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.horizontalPadding(context),
                  AppDimensions.spacing20,
                  ResponsiveUtils.horizontalPadding(context),
                  AppDimensions.spacing40,
                ),

                children: [
                  _buildCategoryHeader(
                    categoryTasks.length,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing20,
                  ),

                  if (categoryTasks.isEmpty)
                    EmptyTasksView(
                      title:
                          'No $categoryName tasks',
                      message:
                          'There are no tasks in this category yet.',
                      icon:
                          Icons.task_alt_rounded,
                    )
                  else
                    TaskList(
                      tasks: categoryTasks,

                      // التصنيفات لا تحتوي على Complete.
                      showCompleteAction: false,

                      onEdit: (task) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddTaskPage(
                              task: task,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<TaskEntity> _getCategoryTasks(
    List<TaskEntity> tasks,
  ) {
    return tasks.where((task) {
      return task.categoryId.toLowerCase() ==
          categoryId.toLowerCase();
    }).toList();
  }

  Widget _buildCategoryHeader(int taskCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppDimensions.spacing16,
      ),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(),
              color: categoryColor,
              size: 22,
            ),
          ),

          const SizedBox(
            width: AppDimensions.spacing12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: AppTextStyles.sectionTitle,
                ),

                const SizedBox(
                  height: AppDimensions.spacing4,
                ),

                Text(
                  '$taskCount '
                  '${taskCount == 1 ? 'task' : 'tasks'}',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    final category = TaskCategories.all.firstWhere(
      (item) => item.id == categoryId,
    );

    return category.icon;
  }
}

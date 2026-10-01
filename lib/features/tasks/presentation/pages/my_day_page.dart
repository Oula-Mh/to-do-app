
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

import '../widgets/empty_tasks_view.dart';
import '../widgets/error_tasks_view.dart';
import '../widgets/task_list.dart';
import 'add_edit_task_page.dart';

class MyDayPage extends StatelessWidget {
  const MyDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          AppStrings.myDay,
          style: AppTextStyles.pageTitle,
        ),
      ),

      body: BlocBuilder<TaskBloc, TaskState>(
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
                  state.errorMessage ??
                  'Something went wrong',
            );
          }

          final tasks = state.todayTasks;

          if (tasks.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    ResponsiveUtils.horizontalPadding(
                  context,
                ),
                vertical: AppDimensions.spacing24,
              ),
              child: Center(
                child: EmptyTasksView(
                  title: 'Your day is clear',
                  message:
                      'No tasks planned for today.\n'
                      'Enjoy your free time or add a new task.',
                  icon: Icons.today_outlined,
                ),
              ),
            );
          }

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
                ResponsiveUtils.horizontalPadding(
                  context,
                ),
                AppDimensions.spacing16,
                ResponsiveUtils.horizontalPadding(
                  context,
                ),
                AppDimensions.spacing40,
              ),
              children: [
                TaskList(
                  tasks: tasks,
                  showCompleteAction: true,
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

      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    return SizedBox(
      width: AppDimensions.fabSize,
      height: AppDimensions.fabSize,
      child: FloatingActionButton(
     onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const AddTaskPage(),
    ),
  );
},
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          size: AppDimensions.iconLarge,
        ),
      ),
    );
  }
}
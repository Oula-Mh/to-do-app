import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

import '../../domain/entities/task.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

import '../widgets/empty_tasks_view.dart';
import '../widgets/error_tasks_view.dart';
import '../widgets/task_list.dart';
import '../widgets/upcoming_calendar.dart';
import '../widgets/upcoming_date_header.dart';

import 'add_edit_task_page.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();

    // Upcoming يبدأ من اليوم التالي.
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    _focusedDay = tomorrow;
    _selectedDay = tomorrow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          AppStrings.upcoming,
          style: AppTextStyles.pageTitle,
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
                    state.errorMessage ??
                    'Something went wrong',
              );
            }

            final selectedTasks =
                _getTasksForSelectedDay(state.tasks);

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
                  UpcomingCalendar(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,

                    onDaySelected: (day) {
                      setState(() {
                        _selectedDay = day;
                      });
                    },

                    onPageChanged: (day) {
                      setState(() {
                        _focusedDay = day;
                      });
                    },
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing24,
                  ),

                  UpcomingDateHeader(
                    selectedDay: _selectedDay,
                    taskCount: selectedTasks.length,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing16,
                  ),

                  if (selectedTasks.isEmpty)
                    const EmptyTasksView(
                      title: 'Your day is clear',
                      message:
                          'There are no tasks planned for this day.',
                      icon:
                          Icons.event_available_rounded,
                    )
                  else
                    TaskList(
                      tasks: selectedTasks,

                      // Upcoming لا يحتوي على Complete.
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

  List<TaskEntity> _getTasksForSelectedDay(
    List<TaskEntity> tasks,
  ) {
    return tasks.where((task) {
      return isSameDay(
        task.date,
        _selectedDay,
      );
    }).toList();
  }
}

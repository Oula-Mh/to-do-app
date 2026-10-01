import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/categories_section.dart';
import '../widgets/home_header.dart';
import '../widgets/task_categories.dart';
import '../widgets/task_overview_card.dart';
import 'add_edit_task_page.dart';
import 'category_tasks_page.dart';
import 'my_day_page.dart';
import 'upcoming_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _buildFab(context),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            // Loading
            if (state.status == TaskStatus.loading && state.tasks.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // Error
            if (state.status == TaskStatus.failure && state.tasks.isEmpty) {
              return _ErrorContent(
                message: state.errorMessage ?? 'Something went wrong',
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<TaskBloc>().add(const LoadTasks());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.horizontalPadding(context),
                      vertical: AppDimensions.spacing20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Header
                        const HomeHeader(),

                        const SizedBox(height: AppDimensions.spacing32),

                        // My Day + Upcoming + Important
                        _buildOverview(context, state),

                        const SizedBox(height: AppDimensions.spacing32),

                        // Categories
                        CategoriesSection(
                          tasks: state.tasks,
                          onCategoryTap: (categoryId) {
                            final category = TaskCategories.all.firstWhere(
                              (item) => item.id == categoryId,
                            );

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => CategoryTasksPage(
                                      categoryId: category.id,
                                      categoryName: category.title,
                                      categoryColor: category.color,
                                    ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacing40),

                        // مساحة إضافية حتى لا يغطي FAB آخر محتوى
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, TaskState state) {
    final isMobile = ResponsiveUtils.isMobile(context);

    final myDayCard = TaskOverviewCard(
      title: 'My Day',
      subtitle:
          '${state.todayTasks.length} '
          '${state.todayTasks.length == 1 ? 'task' : 'tasks'} '
          'for today',
      icon: Icons.today_outlined,
      cardColor: AppColors.blueLight,
      iconColor: AppColors.primary,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MyDayPage()));
      },
    );

    final upcomingCard = TaskOverviewCard(
      title: 'Upcoming',
      subtitle:
          '${state.upcomingTasks.length} '
          '${state.upcomingTasks.length == 1 ? 'task' : 'tasks'} '
          'coming up',
      icon: Icons.calendar_month_outlined,
      cardColor: AppColors.greenLight,
      iconColor: AppColors.green,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const UpcomingPage()));
      },
    );

    final importantCard = TaskOverviewCard(
      title: 'Important',
      subtitle:
          '${state.importantTasks.length} '
          '${state.importantTasks.length == 1 ? 'important task' : 'important tasks'}',
      icon: Icons.star_rounded,
      cardColor: AppColors.yellowLight,
      iconColor: AppColors.yellow,
      onTap: () {
        // TODO: فتح ImportantTasksPage
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppDimensions.spacing12),

        if (isMobile) ...[
          // My Day
          myDayCard,

          const SizedBox(height: AppDimensions.spacing12),

          // Upcoming
          upcomingCard,

          const SizedBox(height: AppDimensions.spacing12),

          // Important
          importantCard,
        ] else ...[
          // My Day + Upcoming
          Row(
            children: [
              Expanded(child: myDayCard),

              const SizedBox(width: AppDimensions.spacing12),

              Expanded(child: upcomingCard),
            ],
          ),

          const SizedBox(height: AppDimensions.spacing12),

          // Important
          importantCard,
        ],
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return SizedBox(
      width: AppDimensions.fabSize,
      height: AppDimensions.fabSize,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddTaskPage()));
        },
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: AppDimensions.iconLarge),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;

  const _ErrorContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.red,
            ),

            const SizedBox(height: AppDimensions.spacing16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: AppDimensions.spacing20),

            FilledButton(
              onPressed: () {
                context.read<TaskBloc>().add(const LoadTasks());
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(120, AppDimensions.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                ),
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

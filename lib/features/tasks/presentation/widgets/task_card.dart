import 'package:flutter/material.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/task.dart';

class TaskCard extends StatefulWidget {
  final TaskEntity task;

  /// يظهر فقط في My Day
  final bool showCompleteAction;

  /// عند حذف المهمة
  final Future<bool?> Function()? onDelete;

  /// عند تعديل المهمة
  final VoidCallback? onEdit;

  /// عند تغيير حالة الإكمال
  final VoidCallback? onComplete;

  const TaskCard({
    required this.task,
    this.showCompleteAction = false,
    this.onDelete,
    this.onEdit,
    this.onComplete,
    super.key,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),

      // السحب من اليمين إلى اليسار = تعديل
      // السحب من اليسار إلى اليمين = حذف
      direction: DismissDirection.horizontal,

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Delete
          if (widget.onDelete == null) {
            return false;
          }

          return await widget.onDelete!();
        }

        if (direction == DismissDirection.endToStart) {
          // Edit
          widget.onEdit?.call();

          // لا نحذف العنصر من القائمة
          return false;
        }

        return false;
      },

      background: _buildDeleteBackground(),
      secondaryBackground: _buildEditBackground(),

      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    final categoryColor = _getCategoryColor(
      widget.task.categoryId,
    );

    return Container(
      constraints: const BoxConstraints(
        minHeight: AppDimensions.taskCardMinHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppDimensions.spacing16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // Header
            // --------------------------------------------------

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category indicator
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(
                  width: AppDimensions.spacing12,
                ),

                // Title
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: AppTextStyles.taskTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(
                  width: AppDimensions.spacing8,
                ),

                // Important
                if (widget.task.isImportant)
                  const Icon(
                    Icons.star_rounded,
                    size: AppDimensions.iconSmall,
                    color: AppColors.yellow,
                  ),
              ],
            ),

            const SizedBox(
              height: AppDimensions.spacing12,
            ),

            // --------------------------------------------------
            // Description
            // --------------------------------------------------

            if (widget.task.description.trim().isNotEmpty)
              _buildDescription(),

            if (widget.task.description.trim().isNotEmpty)
              const SizedBox(
                height: AppDimensions.spacing12,
              ),

            // --------------------------------------------------
            // Date + Time
            // --------------------------------------------------

            _buildDateTime(),

            // --------------------------------------------------
            // Complete button
            // يظهر فقط في My Day
            // --------------------------------------------------

            if (widget.showCompleteAction) ...[
              const SizedBox(
                height: AppDimensions.spacing12,
              ),
              _buildCompleteButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final description = widget.task.description.trim();

    final shouldShowReadMore = description.length > 100;

    if (_isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: AppTextStyles.taskDescription,
          ),

          if (shouldShowReadMore)
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimensions.spacing4,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: const Text(
                  'Show less',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: AppTextStyles.taskDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        if (shouldShowReadMore)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.spacing4,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: const Text(
                'Read more',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateTime() {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: AppDimensions.iconSmall,
          color: AppColors.textSecondary,
        ),

        const SizedBox(
          width: AppDimensions.spacing8,
        ),

        Expanded(
          child: Text(
            _formatDate(widget.task.date),
            style: AppTextStyles.taskTime,
          ),
        ),

        const SizedBox(
          width: AppDimensions.spacing12,
        ),

        const Icon(
          Icons.access_time_rounded,
          size: AppDimensions.iconSmall,
          color: AppColors.textSecondary,
        ),

        const SizedBox(
          width: AppDimensions.spacing8,
        ),

        Text(
          _formatTime(widget.task.date),
          style: AppTextStyles.taskTime,
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    final isCompleted = widget.task.isCompleted;

    return InkWell(
      onTap: widget.onComplete,
      borderRadius: BorderRadius.circular(
        AppDimensions.smallRadius,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.greenLight
              : AppColors.background,
          borderRadius: BorderRadius.circular(
            AppDimensions.smallRadius,
          ),
          border: Border.all(
            color: isCompleted
                ? AppColors.green
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: AppDimensions.iconSmall,
              color: isCompleted
                  ? AppColors.green
                  : AppColors.textSecondary,
            ),

            const SizedBox(
              width: AppDimensions.spacing8,
            ),

            Text(
              isCompleted ? 'Completed' : 'Mark as complete',
              style: TextStyle(
                color: isCompleted
                    ? AppColors.green
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing20,
      ),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.delete_outline_rounded,
            color: AppColors.red,
            size: AppDimensions.iconMedium,
          ),
          SizedBox(
            width: AppDimensions.spacing8,
          ),
          Text(
            'Delete',
            style: TextStyle(
              color: AppColors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing20,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(
          AppDimensions.largeCardRadius,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Edit',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: AppDimensions.spacing8,
          ),
          Icon(
            Icons.edit_outlined,
            color: AppColors.primary,
            size: AppDimensions.iconMedium,
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'personal':
        return AppColors.categoryPersonal;

      case 'work':
        return AppColors.categoryWork;

      case 'learning':
        return AppColors.categoryLearning;

      case 'shopping':
        return AppColors.categoryShopping;

      case 'visits':
        return AppColors.categoryVisits;

      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
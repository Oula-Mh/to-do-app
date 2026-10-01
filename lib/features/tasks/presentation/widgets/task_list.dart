import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_dimensions.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import 'delete_task_dialog.dart';
import 'task_card.dart';

class TaskList extends StatelessWidget {
  final List<TaskEntity> tasks;

  final bool showCompleteAction;

  final void Function(TaskEntity task)? onEdit;

  const TaskList({
    required this.tasks,
    this.showCompleteAction = false,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < tasks.length; i++) ...[
          TaskCard(
            task: tasks[i],

            showCompleteAction: showCompleteAction,

            onDelete: () async {
              final task = tasks[i];

              final confirmed =
                  await showDeleteTaskDialog(context);

              if (confirmed == true && context.mounted) {
                context.read<TaskBloc>().add(
                      DeleteTaskEvent(task.id),
                    );
              }

              return confirmed;
            },

            onEdit: () {
              onEdit?.call(tasks[i]);
            },

            onComplete: showCompleteAction
                ? () {
                    final task = tasks[i];

                    context.read<TaskBloc>().add(
                          CompleteTaskEvent(
                            id: task.id,
                            isCompleted: !task.isCompleted,
                          ),
                        );
                  }
                : null,
          ),

          if (i != tasks.length - 1)
            const SizedBox(
              height: AppDimensions.spacing12,
            ),
        ],
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class ErrorTasksView extends StatelessWidget {
  final String message;

  const ErrorTasksView({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppDimensions.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.red,
            ),

            const SizedBox(
              height: AppDimensions.spacing16,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(
              height: AppDimensions.spacing20,
            ),

            FilledButton(
              onPressed: () {
                context.read<TaskBloc>().add(
                      const LoadTasks(),
                    );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Try again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
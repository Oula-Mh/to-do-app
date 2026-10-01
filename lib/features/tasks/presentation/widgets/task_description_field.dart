import 'package:flutter/material.dart';

import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskDescriptionField
    extends StatelessWidget {
  final TextEditingController controller;

  const TaskDescriptionField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 4,
      maxLines: 6,
      textInputAction:
          TextInputAction.newline,
      style: AppTextStyles.body,
      decoration: const InputDecoration(
        hintText: 'Add some details...',
        alignLabelWithHint: true,
        contentPadding:
            EdgeInsets.all(
          AppDimensions.spacing16,
        ),
      ),
    );
  }
}
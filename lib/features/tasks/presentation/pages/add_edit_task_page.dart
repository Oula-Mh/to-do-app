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

import '../widgets/task_category_selector.dart';
import '../widgets/task_date_time_picker.dart';
import '../widgets/task_description_field.dart';
import '../widgets/task_form_header.dart';
import '../widgets/task_important_selector.dart';

class AddTaskPage extends StatefulWidget {
  final TaskEntity? task;

  const AddTaskPage({this.task, super.key});

  bool get isEditing => task != null;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  late String _selectedCategoryId;
  late bool _isImportant;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    _titleController = TextEditingController(text: task?.title ?? '');

    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );

    final initialDate = task?.date ?? DateTime.now();

    _selectedDate = DateUtils.dateOnly(initialDate);

    _selectedTime = TimeOfDay(
      hour: initialDate.hour,
      minute: initialDate.minute,
    );

    _selectedCategoryId = task?.categoryId ?? 'personal';

    _isImportant = task?.isImportant ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  DateTime _buildTaskDateTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldTask = widget.task;

    final task = TaskEntity(
      id: oldTask?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _buildTaskDateTime(),
      isCompleted: oldTask?.isCompleted ?? false,
      isImportant: _isImportant,
      categoryId: _selectedCategoryId,
    );

    setState(() {
      _isSaving = true;
    });

    if (widget.isEditing) {
      context.read<TaskBloc>().add(UpdateTaskEvent(task));
    } else {
      context.read<TaskBloc>().add(AddTaskEvent(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.horizontalPadding(context);

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (!_isSaving) {
          return;
        }

        if (state.status == TaskStatus.loaded) {
          Navigator.of(context).pop();
          return;
        }

        if (state.status == TaskStatus.failure) {
          setState(() {
            _isSaving = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskFormHeader(
                    isEditing: widget.isEditing,
                    titleController: _titleController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }

                      return null;
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppDimensions.spacing12,
                      horizontalPadding,
                      AppDimensions.spacing40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(title: 'DETAILS'),

                        const SizedBox(height: AppDimensions.spacing12),

                        TaskDescriptionField(
                          controller: _descriptionController,
                        ),

                        const SizedBox(height: AppDimensions.spacing32),

                        const _SectionLabel(title: 'WHEN'),

                        const SizedBox(height: AppDimensions.spacing12),

                        TaskDateTimePicker(
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          onDateChanged: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          onTimeChanged: (time) {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacing32),

                        const _SectionLabel(title: 'CATEGORY'),

                        const SizedBox(height: AppDimensions.spacing12),

                        TaskCategorySelector(
                          selectedCategoryId: _selectedCategoryId,
                          onChanged: (categoryId) {
                            setState(() {
                              _selectedCategoryId = categoryId;
                            });
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacing32),

                        TaskImportantSelector(
                          isImportant: _isImportant,
                          onChanged: (value) {
                            setState(() {
                              _isImportant = value;
                            });
                          },
                        ),

                        const SizedBox(height: AppDimensions.spacing40),

                        SizedBox(
                          width: double.infinity,
                          height: AppDimensions.buttonHeight,
                          child: FilledButton(
                            onPressed: _isSaving ? null : _saveTask,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.textPrimary,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: AppColors.textSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.largeCardRadius,
                                ),
                              ),
                            ),
                            child:
                                _isSaving
                                    ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                    : Text(
                                      widget.isEditing
                                          ? 'Save Changes'
                                          : 'Create Task',
                                      style: AppTextStyles.button,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.small.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

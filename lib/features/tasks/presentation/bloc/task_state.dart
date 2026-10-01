import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

enum TaskStatus {
  initial,
  loading,
  loaded,
  operationLoading,
  failure,
}

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.errorMessage,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
List<TaskEntity> get todayTasks {
  final now = DateTime.now();

  return tasks.where((task) {
    return task.date.year == now.year &&
        task.date.month == now.month &&
        task.date.day == now.day;
  }).toList();
}

List<TaskEntity> get upcomingTasks {
  final now = DateTime.now();

  final todayEnd = DateTime(
    now.year,
    now.month,
    now.day,
    23,
    59,
    59,
  );

  return tasks.where((task) {
    return task.date.isAfter(todayEnd);
  }).toList();
}

List<TaskEntity> get importantTasks {
  return tasks.where((task) => task.isImportant).toList();
}
  @override
  List<Object?> get props => [
        status,
        tasks,
        errorMessage,
      ];
}
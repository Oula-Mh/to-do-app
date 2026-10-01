import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTasks extends TaskEvent {
  const LoadTasks();
}

final class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

final class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

final class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class CompleteTaskEvent extends TaskEvent {
  final String id;
  final bool isCompleted;

  const CompleteTaskEvent({
    required this.id,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        isCompleted,
      ];
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final CompleteTask completeTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.completeTask,
  }) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<CompleteTaskEvent>(_onCompleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TaskStatus.loading,
        clearError: true,
      ),
    );

    final result = await getTasks();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (tasks) {
        emit(
          state.copyWith(
            status: TaskStatus.loaded,
            tasks: tasks,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TaskStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await addTask(event.task);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (task) {
        emit(
          state.copyWith(
            status: TaskStatus.loaded,
            tasks: [
              ...state.tasks,
              task,
            ],
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TaskStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await updateTask(event.task);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedTask) {
        final updatedTasks = state.tasks.map((task) {
          if (task.id == updatedTask.id) {
            return updatedTask;
          }

          return task;
        }).toList();

        emit(
          state.copyWith(
            status: TaskStatus.loaded,
            tasks: updatedTasks,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TaskStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await deleteTask(event.id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        final updatedTasks = state.tasks
            .where(
              (task) => task.id != event.id,
            )
            .toList();

        emit(
          state.copyWith(
            status: TaskStatus.loaded,
            tasks: updatedTasks,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TaskStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await completeTask(
      id: event.id,
      isCompleted: event.isCompleted,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TaskStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedTask) {
        final updatedTasks = state.tasks.map((task) {
          if (task.id == updatedTask.id) {
            return updatedTask;
          }

          return task;
        }).toList();

        emit(
          state.copyWith(
            status: TaskStatus.loaded,
            tasks: updatedTasks,
            clearError: true,
          ),
        );
      },
    );
  }
} 
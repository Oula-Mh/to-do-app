import 'package:dartz/dartz.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';

import '../../../../core/errors/failures.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();

  Future<Either<Failure, TaskEntity>> addTask(TaskEntity task);

  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);

  Future<Either<Failure, Unit>> deleteTask(String id);
  
    Future<Either<Failure, TaskEntity>> completeTask({
    required String id,
    required bool isCompleted,
  });
}
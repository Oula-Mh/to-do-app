import 'package:dartz/dartz.dart';
import 'package:to_do_app/features/tasks/domain/entities/task.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();

      return Right(tasks);
    } catch (e) {
      return Left(
        CacheFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> addTask(
    TaskEntity task,
  ) async {
    try {
      final model = TaskModel.fromEntity(task);

      final result = await remoteDataSource.addTask(model);

      return Right(result);
    } catch (e) {
      return Left(
        CacheFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(
    TaskEntity task,
  ) async {
    try {
      final model = TaskModel.fromEntity(task);

      final result = await remoteDataSource.updateTask(model);

      return Right(result);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return const Left(
          NotFoundFailure('Task not found'),
        );
      }

      return Left(
        CacheFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> completeTask({
    required String id,
    required bool isCompleted,
  }) async {
    try {
      final result = await remoteDataSource.completeTask(
        id: id,
        isCompleted: isCompleted,
      );

      return Right(result);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return const Left(
          NotFoundFailure('Task not found'),
        );
      }

      return Left(
        CacheFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(
    String id,
  ) async {
    try {
      await remoteDataSource.deleteTask(id);

      return const Right(unit);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return const Left(
          NotFoundFailure('Task not found'),
        );
      }

      return Left(
        CacheFailure(e.toString()),
      );
    }
  }
}
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CompleteTask {
  final TaskRepository repository;

  CompleteTask(this.repository);

  Future<Either<Failure, TaskEntity>> call({
    required String id,
    required bool isCompleted,
  }) {
    return repository.completeTask(
      id: id,
      isCompleted: isCompleted,
    );
  }
}
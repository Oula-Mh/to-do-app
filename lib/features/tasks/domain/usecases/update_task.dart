import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return repository.updateTask(task);
  }
}
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteTask(id);
  }
}
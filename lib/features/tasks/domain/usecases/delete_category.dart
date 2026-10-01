import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteCategory(id);
  }
}
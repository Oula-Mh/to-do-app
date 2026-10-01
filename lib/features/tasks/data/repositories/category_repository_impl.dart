import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl
    implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>>
      getCategories() async {
    try {
      final categories =
          await localDataSource.getCategories();

      return Right(categories);
    } catch (e) {
      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(
    Category category,
  ) async {
    try {
      final model =
          CategoryModel.fromEntity(category);

      final result =
          await localDataSource.addCategory(model);

      return Right(result);
    } catch (e) {
      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(
    Category category,
  ) async {
    try {
      final model =
          CategoryModel.fromEntity(category);

      final result =
          await localDataSource.updateCategory(model);

      return Right(result);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return const Left(
          NotFoundFailure('Category not found'),
        );
      }

      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(
    String id,
  ) async {
    try {
      await localDataSource.deleteCategory(id);

      return const Right(unit);
    } catch (e) {
      if (e.toString().contains('not found')) {
        return const Left(
          NotFoundFailure('Category not found'),
        );
      }

      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }
}
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

final class AddCategoryEvent extends CategoryEvent {
  final Category category;

  const AddCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class DeleteCategoryEvent extends CategoryEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}
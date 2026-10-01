import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc
    extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryStatus.loading,
        clearError: true,
      ),
    );

    final result = await getCategories();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CategoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        emit(
          state.copyWith(
            status: CategoryStatus.loaded,
            categories: categories,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await addCategory(event.category);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CategoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (category) {
        emit(
          state.copyWith(
            status: CategoryStatus.loaded,
            categories: [
              ...state.categories,
              category,
            ],
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await updateCategory(event.category);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CategoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedCategory) {
        final categories =
            state.categories.map((category) {
          if (category.id == updatedCategory.id) {
            return updatedCategory;
          }

          return category;
        }).toList();

        emit(
          state.copyWith(
            status: CategoryStatus.loaded,
            categories: categories,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryStatus.operationLoading,
        clearError: true,
      ),
    );

    final result = await deleteCategory(event.id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CategoryStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        final categories = state.categories
            .where(
              (category) => category.id != event.id,
            )
            .toList();

        emit(
          state.copyWith(
            status: CategoryStatus.loaded,
            categories: categories,
            clearError: true,
          ),
        );
      },
    );
  }
}
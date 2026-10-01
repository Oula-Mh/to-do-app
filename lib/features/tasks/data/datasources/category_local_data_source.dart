import '../models/category_model.dart';
import '../../../../core/constant/app_colors.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<CategoryModel> addCategory(
    CategoryModel category,
  );

  Future<CategoryModel> updateCategory(
    CategoryModel category,
  );

  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl
    implements CategoryLocalDataSource {
  final List<CategoryModel> _categories = [
     CategoryModel(
      id: 'personal',
      name: 'Personal',
      colorValue: AppColors.categoryPersonal.value,
    ),
     CategoryModel(
      id: 'work',
      name: 'Work',
      colorValue: AppColors.categoryWork.value,
    ),
     CategoryModel(
      id: 'learning',
      name: 'Learning',
      colorValue: AppColors.categoryLearning.value,
    ),
     CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      colorValue: AppColors.categoryShopping.value,
    ),
     CategoryModel(
      id: 'visits',
      name: 'Visits',
      colorValue: AppColors.categoryVisits.value,
    ),
  ];

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return List<CategoryModel>.from(_categories);
  }

  @override
  Future<CategoryModel> addCategory(
    CategoryModel category,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    _categories.add(category);

    return category;
  }

  @override
  Future<CategoryModel> updateCategory(
    CategoryModel category,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final index = _categories.indexWhere(
      (item) => item.id == category.id,
    );

    if (index == -1) {
      throw Exception('Category not found');
    }

    _categories[index] = category;

    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final index = _categories.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) {
      throw Exception('Category not found');
    }

    _categories.removeAt(index);
  }
}
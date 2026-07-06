import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import 'entities/category.dart';

abstract interface class CategoryRepository {
  Stream<List<Category>> watchCategories({required String userId});

  Future<Either<Failure, Category>> createCategory(Category category);

  Future<Either<Failure, void>> deleteCategory(String categoryId);

  Future<Either<Failure, void>> seedSystemCategoriesIfEmpty({
    required String userId,
  });
}

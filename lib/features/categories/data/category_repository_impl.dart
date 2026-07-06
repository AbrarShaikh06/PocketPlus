import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities/category.dart';
import '../domain/category_repository.dart';
import 'firestore_category_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._dataSource);

  final FirestoreCategoryDataSource _dataSource;

  @override
  Stream<List<Category>> watchCategories({required String userId}) {
    return _dataSource.watchCategories(userId: userId);
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      return Right(await _dataSource.createCategory(category));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      await _dataSource.deleteCategory(categoryId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> seedSystemCategoriesIfEmpty({
    required String userId,
  }) async {
    try {
      await _dataSource.seedSystemCategoriesIfEmpty(userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}

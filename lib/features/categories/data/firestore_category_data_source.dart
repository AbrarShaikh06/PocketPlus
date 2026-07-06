import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/models/models.dart';
import '../domain/entities/category.dart';

abstract interface class FirestoreCategoryDataSource {
  Stream<List<Category>> watchCategories({required String userId});
  Future<Category> createCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<void> seedSystemCategoriesIfEmpty({required String userId});
}

class FirestoreCategoryDataSourceImpl implements FirestoreCategoryDataSource {
  FirestoreCategoryDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('categories');

  @override
  Stream<List<Category>> watchCategories({required String userId}) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) => Category.fromJson(d.data())).toList();
      list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return list;
    });
  }

  @override
  Future<Category> createCategory(Category category) async {
    final id = category.id.isEmpty ? _uuid.v4() : category.id;
    final toCreate = category.copyWith(
      id: id,
      createdAt: category.createdAt ?? DateTime.now(),
    );
    await _col.doc(id).set(toCreate.toJson());
    return toCreate;
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    // System categories are never hard-deleted; soft-delete via deletedAt.
    await _col.doc(categoryId).update({'deletedAt': Timestamp.now()});
  }

  @override
  Future<void> seedSystemCategoriesIfEmpty({required String userId}) async {
    final existing =
        await _col.where('userId', isEqualTo: userId).limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final now = DateTime.now();
    final batch = _firestore.batch();
    var order = 0;
    for (final seed in _defaultCategories) {
      final id = _uuid.v4();
      final category = Category(
        id: id,
        userId: userId,
        name: seed.name,
        icon: seed.icon,
        type: seed.type,
        isSystem: true,
        sortOrder: order++,
        createdAt: now,
      );
      batch.set(_col.doc(id), category.toJson());
    }
    await batch.commit();
  }
}

class _SeedCategory {
  const _SeedCategory(this.name, this.icon, this.type);
  final String name;
  final String icon;
  final TransactionType type;
}

// NOTE: reconstructed default set (the original seed list lived in the deleted
// data source). Adjust names/icons to taste — `icon` is a Material Symbols name.
const List<_SeedCategory> _defaultCategories = [
  _SeedCategory('Sales', 'point_of_sale', TransactionType.income),
  _SeedCategory('Services', 'handyman', TransactionType.income),
  _SeedCategory('Other Income', 'savings', TransactionType.income),
  _SeedCategory('Rent', 'home_work', TransactionType.expense),
  _SeedCategory('Salaries', 'groups', TransactionType.expense),
  _SeedCategory('Supplies', 'inventory_2', TransactionType.expense),
  _SeedCategory('Utilities', 'bolt', TransactionType.expense),
  _SeedCategory('Transport', 'local_shipping', TransactionType.expense),
  _SeedCategory('Food', 'restaurant', TransactionType.expense),
  _SeedCategory('Marketing', 'campaign', TransactionType.expense),
  _SeedCategory('Miscellaneous', 'category', TransactionType.expense),
];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/khata_customer.dart';
import '../domain/entities/khata_entry.dart';

abstract interface class FirestoreKhataDataSource {
  Stream<List<KhataCustomer>> watchCustomers({
    required String userId,
    required String profileId,
  });
  Stream<List<KhataEntry>> watchCustomerEntries(String customerId);
  Future<KhataCustomer> createCustomer(KhataCustomer customer);

  /// Adds a credit/repayment entry and updates the customer balance atomically.
  /// `creditGiven` increases the balance owed; `repaymentReceived` reduces it.
  Future<void> addEntry({
    required String customerId,
    required int amountPaise,
    required KhataEntryType type,
    String? note,
  });

  Future<void> softDeleteCustomer(String customerId);
}

class FirestoreKhataDataSourceImpl implements FirestoreKhataDataSource {
  FirestoreKhataDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _customers =>
      _firestore.collection('khata_customers');
  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('khata_entries');

  @override
  Stream<List<KhataCustomer>> watchCustomers({
    required String userId,
    required String profileId,
  }) {
    return _customers
        .where('userId', isEqualTo: userId)
        .where('profileId', isEqualTo: profileId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => KhataCustomer.fromJson(d.data())).toList(),
        );
  }

  @override
  Stream<List<KhataEntry>> watchCustomerEntries(String customerId) {
    return _entries
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) => KhataEntry.fromJson(d.data())).toList();
      list.sort((a, b) => b.entryDate.compareTo(a.entryDate));
      return list;
    });
  }

  @override
  Future<KhataCustomer> createCustomer(KhataCustomer customer) async {
    final id = customer.id.isEmpty ? _uuid.v4() : customer.id;
    final now = DateTime.now();
    final toCreate = customer.copyWith(
      id: id,
      createdAt: now,
      updatedAt: now,
    );
    await _customers.doc(id).set(toCreate.toJson());
    return toCreate;
  }

  @override
  Future<void> addEntry({
    required String customerId,
    required int amountPaise,
    required KhataEntryType type,
    String? note,
  }) async {
    final customerRef = _customers.doc(customerId);
    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(customerRef);
      if (!snap.exists) {
        throw StateError('Khata customer $customerId not found');
      }
      final customer = KhataCustomer.fromJson(snap.data()!);
      final delta =
          type == KhataEntryType.creditGiven ? amountPaise : -amountPaise;
      final now = DateTime.now();
      final entryId = _uuid.v4();
      final entry = KhataEntry(
        id: entryId,
        customerId: customerId,
        userId: customer.userId,
        amount: amountPaise,
        entryType: type,
        note: note,
        entryDate: now,
        createdAt: now,
      );
      txn.set(_entries.doc(entryId), entry.toJson());
      txn.update(customerRef, {
        'balance': customer.balance + delta,
        'updatedAt': Timestamp.fromDate(now),
      });
    });
  }

  @override
  Future<void> softDeleteCustomer(String customerId) async {
    await _customers.doc(customerId).update({
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }
}

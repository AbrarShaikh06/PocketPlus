import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:uuid/uuid.dart';

import '../../../shared/models/models.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../domain/entities/invoice.dart';

abstract interface class FirestoreInvoiceDataSource {
  Stream<List<Invoice>> watchInvoices({
    required String userId,
    required String profileId,
  });
  Future<Invoice> createInvoice(Invoice invoice);
  Future<Invoice> updateInvoice(Invoice invoice);
  Future<void> markAsPaid(String invoiceId);
  Future<void> softDeleteInvoice(String invoiceId);
}

class FirestoreInvoiceDataSourceImpl implements FirestoreInvoiceDataSource {
  FirestoreInvoiceDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('invoices');

  @override
  Stream<List<Invoice>> watchInvoices({
    required String userId,
    required String profileId,
  }) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('profileId', isEqualTo: profileId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) => Invoice.fromJson(d.data())).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Creates the invoice with a server-generated, atomically-incremented
  /// invoice number (CLAUDE.md: the client never generates invoice numbers).
  @override
  Future<Invoice> createInvoice(Invoice invoice) async {
    final id = invoice.id.isEmpty ? _uuid.v4() : invoice.id;
    final counterRef = _firestore
        .collection('invoice_counters')
        .doc('${invoice.userId}_${invoice.profileId}');
    final invoiceRef = _col.doc(id);

    return _firestore.runTransaction<Invoice>((txn) async {
      final counterSnap = await txn.get(counterRef);
      final current = (counterSnap.data()?['seq'] as int?) ?? 0;
      final next = current + 1;
      final number = 'INV-${next.toString().padLeft(4, '0')}';

      final toCreate = invoice.copyWith(id: id, invoiceNumber: number);
      txn.set(counterRef, {'seq': next}, SetOptions(merge: true));
      txn.set(invoiceRef, toCreate.toJson());
      return toCreate;
    });
  }

  @override
  Future<Invoice> updateInvoice(Invoice invoice) async {
    final updated = invoice.copyWith(updatedAt: DateTime.now());
    await _col.doc(invoice.id).set(updated.toJson());
    return updated;
  }

  /// Atomic invoice→transaction: marks the invoice PAID and creates the
  /// matching income transaction in a single Firestore transaction
  /// (CLAUDE.md: if it fails, nothing is written).
  @override
  Future<void> markAsPaid(String invoiceId) async {
    final invoiceRef = _col.doc(invoiceId);

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(invoiceRef);
      if (!snap.exists) {
        throw StateError('Invoice $invoiceId not found');
      }
      final invoice = Invoice.fromJson(snap.data()!);
      if (invoice.status == InvoiceStatus.paid) return;

      final now = DateTime.now();
      final txnId = _uuid.v4();
      final transactionRef = _firestore.collection('transactions').doc(txnId);
      final transaction = Transaction(
        id: txnId,
        userId: invoice.userId,
        profileId: invoice.profileId,
        amount: invoice.grandTotal,
        type: TransactionType.income,
        source: TransactionSource.invoice,
        transactionDate: now,
        merchantName: invoice.customerName,
        note: 'Invoice ${invoice.invoiceNumber}',
        invoiceId: invoice.id,
        createdAt: now,
        updatedAt: now,
      );

      txn.set(transactionRef, transaction.toJson());
      txn.update(invoiceRef, {
        'status': InvoiceStatus.paid.name,
        'paidAmount': invoice.grandTotal,
        'paidAt': Timestamp.fromDate(now),
        'transactionId': txnId,
        'updatedAt': Timestamp.fromDate(now),
      });
    });
  }

  @override
  Future<void> softDeleteInvoice(String invoiceId) async {
    await _col.doc(invoiceId).update({
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }
}

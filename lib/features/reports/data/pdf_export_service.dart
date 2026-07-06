import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../domain/entities/report_summary.dart';

class PdfExportService {
  PdfExportService({required this.firestore, required this.firebaseAuth});

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  /// Fetches the current user's transactions for [profileId] within [range].
  Future<List<Transaction>> fetchTransactions(
    String profileId,
    DateTimeRange range,
  ) async {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null) return const [];
    final snap = await firestore
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        .where('profileId', isEqualTo: profileId)
        .where('isDeleted', isEqualTo: false)
        .get();
    final txns = snap.docs
        .map((d) => Transaction.fromJson(d.data()))
        .where(
          (t) =>
              !t.transactionDate.isBefore(range.start) &&
              !t.transactionDate.isAfter(range.end),
        )
        .toList();
    txns.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return txns;
  }

  Future<File> generatePDF(
    List<Transaction> txns,
    ReportSummary summary,
    String businessName,
    DateTimeRange range,
  ) async {
    final df = DateFormat('dd MMM yyyy');
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: businessName),
          pw.Text(
            'Report: ${df.format(range.start)} – ${df.format(range.end)}',
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            'Total Income: ${CurrencyFormatter.format(summary.totalIncome)}',
          ),
          pw.Text(
            'Total Expense: ${CurrencyFormatter.format(summary.totalExpense)}',
          ),
          pw.Text('Net Profit: ${CurrencyFormatter.format(summary.netProfit)}'),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Type', 'Amount', 'Note'],
            data: txns
                .map(
                  (t) => [
                    df.format(t.transactionDate),
                    t.type.name.toUpperCase(),
                    CurrencyFormatter.format(t.amount),
                    t.merchantName ?? t.note ?? '',
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/pocketplus_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await doc.save());
    return file;
  }

  Future<void> shareReport(File file, {String? text}) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: text ?? 'PocketPlus Report',
      ),
    );
  }
}

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService(
    firestore: ref.watch(firestoreProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

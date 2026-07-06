import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/sms_capture_service.dart';
import '../data/sms_parser.dart';
import '../data/bank_pattern_matcher.dart';
import '../data/sms_permission_service.dart';

/// Debug screen to diagnose SMS capture pipeline issues.
class SmsDiagnosticsScreen extends ConsumerStatefulWidget {
  const SmsDiagnosticsScreen({super.key});

  @override
  ConsumerState<SmsDiagnosticsScreen> createState() =>
      _SmsDiagnosticsScreenState();
}

class _SmsDiagnosticsScreenState extends ConsumerState<SmsDiagnosticsScreen> {
  String _permissionStatus = 'Checking...';
  final List<String> _parseResults = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final service = ref.read(smsPermissionServiceProvider);
    final status = await service.status();
    setState(() {
      _permissionStatus = '${status.name} (granted: ${status.isGranted})';
    });
  }

  Future<void> _testParse(String smsText, String senderId) async {
    final parser = ref.read(smsParserProvider);
    final result = parser.parse(smsText, senderId);
    setState(() {
      if (result != null) {
        _parseResults.insert(
            0,
            '✅ Amount: ${result.amount}paise (₹${(result.amount / 100).toStringAsFixed(2)})\n'
            '   Type: ${result.type.name}\n'
            '   Merchant: ${result.merchantName ?? "N/A"}\n'
            '   Sender: $senderId');
      } else {
        _parseResults.insert(
          0,
          '❌ Parse FAILED for sender=$senderId text="$smsText"',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(smsCaptureServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('SMS Diagnostics', style: TextStyle(fontSize: 18)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Permission Status Card
            _buildCard(
              title: 'SMS Permission Status',
              children: [
                Text(
                  _permissionStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _checkPermission,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final service = ref.read(smsPermissionServiceProvider);
                    await service.requestPermission();
                    _checkPermission();
                  },
                  icon: const Icon(Icons.sms, size: 18),
                  label: const Text('Request Permission'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),

            // Capture Stats Card
            _buildCard(
              title: 'Capture Stats',
              children: [
                Text('Total SMS processed: ${service.totalSmsProcessed}'),
                Text('Total parsed: ${service.totalParsed}'),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),

            // Manual Test Card
            _buildCard(
              title: 'Manual Parse Test',
              children: [
                const Text('Tap a sample SMS to test the parser:'),
                const SizedBox(height: 8),
                ..._sampleSms().map(
                  (sample) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () =>
                          _testParse(sample['text']!, sample['sender']!),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sample['sender']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              sample['text']!,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),

            // Parse Results Card
            _buildCard(
              title: 'Parse Results (most recent first)',
              children: _parseResults.isEmpty
                  ? [const Text('No tests run yet')]
                  : _parseResults
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(r, style: const TextStyle(fontSize: 12)),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: AppSizes.spacing12),

            // Known Bank Senders Card
            _buildCard(
              title: 'Known Bank Senders (BankPatternMatcher)',
              children: [
                const Text('Test if a sender ID is recognized:'),
                const SizedBox(height: 8),
                ...[
                  'IC-ICICIB',
                  'ICICIB',
                  'ICICIBK',
                  'HDFCBK',
                  'VM-HDFCBK',
                  'SBI',
                  'SBIBNK',
                  'AXISBK',
                  'KOTAKB',
                  'YESBANK',
                  'PAYTM',
                  'GPAY',
                ].map((id) {
                  final matcher = ref.read(bankPatternMatcherProvider);
                  final known = matcher.isKnownBankSender(id);
                  return Text(
                    '$id → ${known ? "✅ KNOWN" : "❌ UNKNOWN"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: known ? Colors.green : Colors.red,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(AppSizes.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  List<Map<String, String>> _sampleSms() {
    return [
      {
        'text': 'Rs.35 debited from A/c XXXX1234 via UPI Ref No 123456789012',
        'sender': 'ICICIB',
      },
      {
        'text': 'INR 250 spent on UPI at Zomato. Avl Bal: Rs.12,500.00',
        'sender': 'HDFCBK',
      },
      {
        'text': 'Rs 500 paid to ABC Store via UPI. Ref No 987654321098',
        'sender': 'SBI',
      },
      {
        'text':
            'Dear Customer, A/c X1234 credited with ₹12,500.00 via UPI Ref: 6192839.',
        'sender': 'HDFCBK',
      },
      {
        'text': 'You have spent INR 120 at XYZ Bakery on UPI',
        'sender': 'AXISBK',
      },
      {
        'text': 'Rs.1,234.50 debited from A/c XX5678 at POS at Big Bazaar',
        'sender': 'ICICIB',
      },
      {
        'text':
            'Dear Customer, A/c XX1234 debited by Rs.350.00 on 19Jun26. Trf to Swiggy-ref123456.',
        'sender': 'ICICIB',
      },
      {
        'text': '₹200 cashback credited to your card. Thank you for using UPI!',
        'sender': 'KOTAKB',
      },
      {
        'text':
            'Your A/c XX7890 has been credited with Rs.5,000.00 from ABC Corp. Ref 12345.',
        'sender': 'HDFCBK',
      },
      {
        'text':
            'Payment of Rs.750.00 made to ELECTRICITY BOARD via NetBanking. Ref: 98765.',
        'sender': 'YESBANK',
      },
    ];
  }
}

const smsDiagnosticsRoute = '/sms-diagnostics';

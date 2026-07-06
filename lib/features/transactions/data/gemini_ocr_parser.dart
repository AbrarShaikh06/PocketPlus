import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/ai/gemini_rate_limiter.dart';
import '../../../core/config/remote_config_service.dart';

part 'gemini_ocr_parser.freezed.dart';

@freezed
abstract class OcrLineItem with _$OcrLineItem {
  const factory OcrLineItem({
    required String description,
    required int amount, // stored in paise
  }) = _OcrLineItem;
}

@freezed
abstract class OcrParseResult with _$OcrParseResult {
  const factory OcrParseResult({
    int? amount, // stored in paise
    String? merchantName,
    DateTime? transactionDate,
    List<OcrLineItem>? items,
    required bool isForeignCurrency,
    String? currencyCode,
    required bool isNoReceipt,
    required bool isBlurry,
  }) = _OcrParseResult;
}

class GeminiOcrParser {
  final HttpClient _client;
  final GeminiRateLimiter _rateLimiter;

  GeminiOcrParser({
    HttpClient? client,
    required GeminiRateLimiter rateLimiter,
  })  : _client = client ?? HttpClient(),
        _rateLimiter = rateLimiter;

  Future<OcrParseResult?> parseReceipt(File imageFile) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      return null;
    }

    // Cost guard — throws GeminiRateLimitException when over the usage limit.
    await _rateLimiter.consume();

    try {
      // 1. Compress image to max 1MB using flutter_image_compress
      // (target: quality 85, max width/height 1920px)
      Uint8List? compressedBytes;
      try {
        compressedBytes = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          minWidth: 1920,
          minHeight: 1920,
          quality: 85,
          format: CompressFormat.jpeg,
        );

        // 3. If compressed size still > 1MB: reduce quality to 70
        if (compressedBytes != null && compressedBytes.length > 1024 * 1024) {
          final reducedBytes = await FlutterImageCompress.compressWithFile(
            imageFile.absolute.path,
            minWidth: 1920,
            minHeight: 1920,
            quality: 70,
            format: CompressFormat.jpeg,
          );
          if (reducedBytes != null) {
            compressedBytes = reducedBytes;
          }
        }
      } catch (_) {
        // Fallback in case of lack of platform implementation in tests or other issue
        try {
          compressedBytes = await imageFile.readAsBytes();
        } catch (_) {}
      }

      if (compressedBytes == null) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }

      // 2. Convert to base64 JPEG string
      final base64Image = base64Encode(compressedBytes);

      // Key travels in a header, never in the URL — query strings end up in
      // request logs and crash reports. Model id comes from Remote Config so
      // a retirement can be handled without an app update.
      final model = RemoteConfigService.instance.flags.geminiModel;
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
      );

      const systemPrompt =
          'You are a receipt OCR parser for an Indian business app.\n'
          'Respond ONLY with a JSON object. No explanation, no markdown, no backticks.';

      const userPrompt = 'Extract transaction data from this receipt image.\n'
          'Respond ONLY with:\n'
          '{\n'
          '  "amount": 45050,\n'
          '  "merchantName": "Store Name",\n'
          '  "date": "2026-06-11",\n'
          '  "items": [{"description": "Item", "amount": 10000}],\n'
          '  "isForeignCurrency": false,\n'
          '  "isNoReceipt": false,\n'
          '  "isBlurry": false\n'
          '}\n'
          'amount must be in paise (integer). date in YYYY-MM-DD.\n'
          'If image is blurry/unreadable: { "isBlurry": true }\n'
          'If no receipt found: { "isNoReceipt": true }\n'
          'If foreign currency detected: { "isForeignCurrency": true, "currencyCode": "USD" }';

      final payload = {
        'contents': [
          {
            'parts': [
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Image,
                },
              },
              {'text': userPrompt},
            ],
          },
        ],
        'systemInstruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
        'generationConfig': {
          'maxOutputTokens': 512,
          'responseMimeType': 'application/json',
        },
      };

      final request =
          await _client.postUrl(uri).timeout(const Duration(seconds: 10));
      request.headers.contentType = ContentType.json;
      request.headers.set('x-goog-api-key', apiKey);
      request.write(jsonEncode(payload));

      final response =
          await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }

      final responseBody = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 10));

      var text = responseBody.trim();
      final Map<String, dynamic> responseData = jsonDecode(text);
      final candidates = responseData['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }
      final content = candidates[0]['content'] as Map?;
      if (content == null) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }
      final parts = content['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }
      var textResult = parts[0]['text'] as String?;
      if (textResult == null) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }

      textResult = textResult.trim();
      // Strip markdown code fences if present
      if (textResult.startsWith('```json')) {
        textResult = textResult.substring(7);
      } else if (textResult.startsWith('```')) {
        textResult = textResult.substring(3);
      }
      if (textResult.endsWith('```')) {
        textResult = textResult.substring(0, textResult.length - 3);
      }
      textResult = textResult.trim();

      final parsed = jsonDecode(textResult) as Map<String, dynamic>;

      final isBlurry = parsed['isBlurry'] == true;
      final isNoReceipt = parsed['isNoReceipt'] == true;
      final isForeignCurrency = parsed['isForeignCurrency'] == true;
      final currencyCode = parsed['currencyCode'] as String?;

      if (isBlurry) {
        return const OcrParseResult(
          isBlurry: true,
          isNoReceipt: false,
          isForeignCurrency: false,
        );
      }

      if (isNoReceipt) {
        return const OcrParseResult(
          isBlurry: false,
          isNoReceipt: true,
          isForeignCurrency: false,
        );
      }

      final amount = parsed['amount'] as int?;
      final merchantName = parsed['merchantName'] as String?;

      DateTime? transactionDate;
      final dateStr = parsed['date'] as String?;
      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          transactionDate = DateTime.parse(dateStr);
        } catch (_) {}
      }

      final itemsRaw = parsed['items'] as List?;
      final List<OcrLineItem>? items = itemsRaw?.map((item) {
        final m = Map<String, dynamic>.from(item as Map);
        return OcrLineItem(
          description: m['description'] as String? ?? '',
          amount: m['amount'] as int? ?? 0,
        );
      }).toList();

      return OcrParseResult(
        amount: amount,
        merchantName: merchantName,
        transactionDate: transactionDate,
        items: items,
        isForeignCurrency: isForeignCurrency,
        currencyCode: currencyCode,
        isNoReceipt: false,
        isBlurry: false,
      );
    } catch (_) {
      // 10-second timeout: cancel request + return OcrParseResult(isBlurry: true) if exceeded
      return const OcrParseResult(
        isBlurry: true,
        isNoReceipt: false,
        isForeignCurrency: false,
      );
    }
  }
}

final geminiOcrParserProvider = Provider<GeminiOcrParser>((ref) {
  return GeminiOcrParser(rateLimiter: ref.watch(geminiRateLimiterProvider));
});

import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/ai/gemini_rate_limiter.dart';
import '../../../core/config/remote_config_service.dart';
import '../../categories/domain/entities/category.dart';
import '../../../shared/models/models.dart';

part 'gemini_voice_parser.freezed.dart';

@freezed
abstract class VoiceParseResult with _$VoiceParseResult {
  const factory VoiceParseResult({
    int? amount, // stored in paise
    required TransactionType type,
    String? categoryId,
    String? note,
  }) = _VoiceParseResult;
}

class GeminiVoiceParser {
  final HttpClient _client;
  final GeminiRateLimiter _rateLimiter;

  GeminiVoiceParser({
    HttpClient? client,
    required GeminiRateLimiter rateLimiter,
  })  : _client = client ?? HttpClient(),
        _rateLimiter = rateLimiter;

  Future<VoiceParseResult?> parse(
    String transcript,
    List<Category> availableCategories,
  ) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      return null;
    }

    // Cost guard — throws GeminiRateLimitException when over the usage limit.
    await _rateLimiter.consume();

    try {
      // Key travels in a header, never in the URL — query strings end up in
      // request logs and crash reports. Model id comes from Remote Config so
      // a retirement can be handled without an app update.
      final model = RemoteConfigService.instance.flags.geminiModel;
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
      );

      final categoriesJson = availableCategories
          .map(
            (c) => {
              'id': c.id,
              'name': c.name,
            },
          )
          .toList();

      const systemPrompt =
          'You are a voice transaction parser for an Indian business expense tracking app.\n'
          'The user will describe a financial transaction in Hindi or English.\n'
          'Respond ONLY with a JSON object. No explanation, no markdown, no backticks.';

      final userPrompt = 'User said: "$transcript"\n'
          'Available categories: ${jsonEncode(categoriesJson)}\n'
          'Respond ONLY with:\n'
          '{ "amount": 45050, "type": "EXPENSE", "categoryId": "uuid-here", "note": "optional note" }\n'
          'amount must be in paise (integer). type must be INCOME or EXPENSE.\n'
          'If you cannot determine amount: { "amount": null }\n'
          'If you cannot determine category: { "categoryId": null }';

      final payload = {
        'contents': [
          {
            'parts': [
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
        return null;
      }

      final responseBody = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> data = jsonDecode(responseBody);
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return null;
      }
      final content = candidates[0]['content'] as Map?;
      if (content == null) {
        return null;
      }
      final parts = content['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        return null;
      }
      var text = parts[0]['text'] as String?;
      if (text == null) {
        return null;
      }

      text = text.trim();
      // Strip markdown code fences if present
      if (text.startsWith('```json')) {
        text = text.substring(7);
      } else if (text.startsWith('```')) {
        text = text.substring(3);
      }
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
      text = text.trim();

      final parsed = jsonDecode(text) as Map<String, dynamic>;
      final amount = parsed['amount'] as int?;
      final typeStr = parsed['type'] as String?;
      final categoryId = parsed['categoryId'] as String?;
      final note = parsed['note'] as String?;

      final type = typeStr?.toUpperCase() == 'INCOME'
          ? TransactionType.income
          : TransactionType.expense;

      return VoiceParseResult(
        amount: amount,
        type: type,
        categoryId: categoryId,
        note: note,
      );
    } catch (_) {
      return null;
    }
  }
}

final geminiVoiceParserProvider = Provider<GeminiVoiceParser>((ref) {
  return GeminiVoiceParser(rateLimiter: ref.watch(geminiRateLimiterProvider));
});

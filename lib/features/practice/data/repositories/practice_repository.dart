import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/athkar_model.dart';

class PracticeRepository {
  Future<AthkarData> loadAthkarData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/bundle/athkar/Adhkar-json/adhkar.json',
      );
      final dynamic jsonResponse = json.decode(jsonString);

      if (jsonResponse is List) {
        return AthkarData(
          version: '1.0',
          language: 'ar',
          sourcePolicy: '',
          categories: jsonResponse
              .map((e) => AthkarCategory.fromJson(e))
              .toList(),
        );
      } else {
        return AthkarData.fromJson(jsonResponse);
      }
    } catch (e) {
      throw Exception('Failed to load Athkar data: $e');
    }
  }

  Future<List<AthkarSearchResult>> searchAthkar(String query) async {
    if (query.isEmpty) return [];

    final data = await loadAthkarData();
    final List<AthkarSearchResult> results = [];
    final normalizedQuery = _normalizeArabic(query.toLowerCase());

    for (final category in data.categories) {
      for (final item in category.items) {
        final text = item.text;
        final title = item.title ?? '';

        if (_normalizeArabic(text).contains(normalizedQuery) ||
            _normalizeArabic(title).contains(normalizedQuery)) {
          results.add(
            AthkarSearchResult(
              item: item,
              categoryTitle: category.title,
              categoryId: category.id,
            ),
          );
        }
      }
    }
    return results;
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '') // Remove Tashkeel
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll(
          'ة',
          'h',
        ) // Sometimes people type h for ta marbuta or just skip it.
        // Actually for Arabic search, usually we normalize Alef and maybe Ta Marbuta/Ha.
        // Let's stick to basics: remove Tashkeel and normalize Alefs.
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}

class AthkarSearchResult {
  final AthkarItem item;
  final String categoryTitle;
  final String categoryId;

  AthkarSearchResult({
    required this.item,
    required this.categoryTitle,
    required this.categoryId,
  });
}

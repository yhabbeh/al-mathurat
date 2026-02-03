import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/athkar_model.dart';

class PracticeRepository {
  Future<AthkarData> loadAthkarData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/bundle/athkar.json',
      );
      final jsonMap = json.decode(jsonString);
      return AthkarData.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load Athkar data: $e');
    }
  }
}

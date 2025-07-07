import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/golf_swing.dart';

class GolfSwingService {
  static Future<List<GolfSwing>> loadAllSwings() async {
    final List<GolfSwing> swings = [];
    int fileIndex = 1;

    // Keep trying to load files until we find one that doesn't exist
    while (true) {
      final fileName = '$fileIndex.json';
      try {
        final jsonString = await rootBundle.loadString(
          'exampleJSONS/$fileName',
        );
        final jsonData = json.decode(jsonString);
        final swing = GolfSwing.fromJson(jsonData, fileName);
        swings.add(swing);
        fileIndex++;
      } catch (e) {
        // File doesn't exist, we've loaded all available files
        break;
      }
    }

    return swings;
  }
}

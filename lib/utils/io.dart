import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyIO {
  static final prefs = SharedPreferencesAsync();
  static Future<String?> load(String id) async {
    return await prefs.getString(id);
  }

  static Future<void> save(String id, String value) async {
    await prefs.setString(id, value);
  }

  static Future<Map<String, dynamic>?> loadJson(String id) async {
    String? json = await prefs.getString(id);
    return (json == null) ? null : jsonDecode(json);
  }
  
  static Future<String> loadOrNew(String id, String defaultValue) async {
    if (await load(id) == null) {
      await save(id, defaultValue);
    }

    return (await load(id))!;
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocaleService {
  static const String _languageCodeKey = 'en';

  static Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }


  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageCodeKey);
    if (code != null) {
      return Locale(code);
    }
    return null;
  }
}

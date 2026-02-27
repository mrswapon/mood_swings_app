import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mood_swings_app/constants/app_constants.dart';
import 'package:mood_swings_app/models/mood_entry.dart';
import 'package:mood_swings_app/services/storage_service.dart';

class LocalStorageService implements StorageService {
  late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<List<MoodEntry>> loadEntries() async {
    final raw = _prefs.getString(AppConstants.storageKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveEntries(List<MoodEntry> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(AppConstants.storageKey, encoded);
  }

  @override
  Future<void> clearEntries() async {
    await _prefs.remove(AppConstants.storageKey);
  }

  @override
  Future<bool> loadThemePreference() async {
    return _prefs.getBool(AppConstants.themeKey) ?? false;
  }

  @override
  Future<void> saveThemePreference(bool isDark) async {
    await _prefs.setBool(AppConstants.themeKey, isDark);
  }
}

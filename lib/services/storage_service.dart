import 'package:mood_swings_app/models/mood_entry.dart';

abstract class StorageService {
  Future<void> init();
  Future<List<MoodEntry>> loadEntries();
  Future<void> saveEntries(List<MoodEntry> entries);
  Future<void> clearEntries();
  Future<bool> loadThemePreference();
  Future<void> saveThemePreference(bool isDark);
}

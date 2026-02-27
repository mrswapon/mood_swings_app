import 'package:flutter/foundation.dart';
import 'package:mood_swings_app/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage;
  bool _isDarkMode = false;

  ThemeProvider(this._storage);

  bool get isDarkMode => _isDarkMode;

  Future<void> loadPreference() async {
    _isDarkMode = await _storage.loadThemePreference();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.saveThemePreference(_isDarkMode);
    notifyListeners();
  }
}

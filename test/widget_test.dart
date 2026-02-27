import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/app.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/providers/theme_provider.dart';
import 'package:mood_swings_app/services/storage_service.dart';
import 'package:mood_swings_app/models/mood_entry.dart';

class MockStorageService implements StorageService {
  @override
  Future<void> init() async {}
  @override
  Future<List<MoodEntry>> loadEntries() async => [];
  @override
  Future<void> saveEntries(List<MoodEntry> entries) async {}
  @override
  Future<void> clearEntries() async {}
  @override
  Future<bool> loadThemePreference() async => false;
  @override
  Future<void> saveThemePreference(bool isDark) async {}
}

void main() {
  testWidgets('App launches and shows Home tab', (WidgetTester tester) async {
    final storage = MockStorageService();
    final moodProvider = MoodProvider(storage);
    final themeProvider = ThemeProvider(storage);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: moodProvider),
          ChangeNotifierProvider.value(value: themeProvider),
        ],
        child: const MoodSwingsApp(),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

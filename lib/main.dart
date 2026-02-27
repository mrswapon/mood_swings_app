import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/app.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/providers/theme_provider.dart';
import 'package:mood_swings_app/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //=======================> Initialize storage <=============
  final storageService = LocalStorageService();
  await storageService.init();

  //=======================> Create providers <=============
  final moodProvider = MoodProvider(storageService);
  final themeProvider = ThemeProvider(storageService);

  //=======================> Load persisted data <=============
  await Future.wait([
    moodProvider.loadEntries(),
    themeProvider.loadPreference(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: moodProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: const MoodSwingsApp(),
    ),
  );
}

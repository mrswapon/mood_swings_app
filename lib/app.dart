import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/constants/app_constants.dart';
import 'package:mood_swings_app/providers/theme_provider.dart';
import 'package:mood_swings_app/screens/shell_screen.dart';
import 'package:mood_swings_app/theme/app_theme.dart';

class MoodSwingsApp extends StatelessWidget {
  const MoodSwingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const ShellScreen(),
        );
      },
    );
  }
}

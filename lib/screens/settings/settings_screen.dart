import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final moodProvider = context.read<MoodProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 24),

          //=======================> Appearance section <=============
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle dark theme'),
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),

          //=======================> Data section <=============
          Text(
            'Data',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Clear All Data'),
              subtitle: const Text('Delete all mood entries'),
              onTap: () => _confirmClearData(context, moodProvider),
            ),
          ),
          const SizedBox(height: 24),

          //=======================> About section <=============
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Mood Swings'),
              subtitle: const Text('Version 1.0.0'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Mood Swings',
                applicationVersion: '1.0.0',
                applicationIcon: const Text(
                  '\u{1F308}',
                  style: TextStyle(fontSize: 48),
                ),
                children: [
                  const Text(
                    'Track your daily emotions, identify patterns, '
                    'and build better self-awareness.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          //=======================> Footer <=============
          Center(
            child: Text(
              'Made with \u{2764} in Flutter',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearData(BuildContext context, MoodProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your mood entries. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

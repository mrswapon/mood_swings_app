import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_swings_app/constants/app_constants.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/models/mood_entry.dart';
import 'package:mood_swings_app/providers/mood_provider.dart';
import 'package:mood_swings_app/utils/id_generator.dart';
import 'package:mood_swings_app/widgets/activity_chip.dart';
import 'package:mood_swings_app/widgets/mood_selector.dart';

class MoodEntryScreen extends StatefulWidget {
  final MoodEntry? existingEntry;

  const MoodEntryScreen({super.key, this.existingEntry});

  @override
  State<MoodEntryScreen> createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  MoodType? _selectedMood;
  late TextEditingController _noteController;
  final Set<String> _selectedActivities = {};
  bool get _isEditing => widget.existingEntry != null;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    if (_isEditing) {
      _selectedMood = widget.existingEntry!.moodType;
      _noteController.text = widget.existingEntry!.note ?? '';
      _selectedActivities.addAll(widget.existingEntry!.activities);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    final provider = context.read<MoodProvider>();
    final note = _noteController.text.trim();

    if (_isEditing) {
      final updated = widget.existingEntry!.copyWith(
        moodType: _selectedMood,
        note: note.isEmpty ? null : note,
        activities: _selectedActivities.toList(),
      );
      provider.updateEntry(updated);
    } else {
      final entry = MoodEntry(
        id: IdGenerator.generate(),
        moodType: _selectedMood!,
        note: note.isEmpty ? null : note,
        dateTime: DateTime.now(),
        activities: _selectedActivities.toList(),
      );
      provider.addEntry(entry);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Entry' : 'How are you feeling?'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood selector
            Text(
              'Select your mood',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            MoodSelector(
              selected: _selectedMood,
              onSelected: (mood) => setState(() => _selectedMood = mood),
            ),
            const SizedBox(height: 32),

            // Note field
            Text(
              'Add a note (optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'What made you feel this way?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color ??
                    Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 24),

            // Activities
            Text(
              'Activities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: AppConstants.defaultActivities.map((activity) {
                final isSelected = _selectedActivities.contains(activity);
                return ActivityChip(
                  label: activity,
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedActivities.add(activity);
                      } else {
                        _selectedActivities.remove(activity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Update Entry' : 'Save Entry',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

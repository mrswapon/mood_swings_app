import 'package:mood_swings_app/constants/mood_constants.dart';

class MoodEntry {
  final String id;
  final MoodType moodType;
  final String? note;
  final DateTime dateTime;
  final List<String> activities;

  const MoodEntry({
    required this.id,
    required this.moodType,
    this.note,
    required this.dateTime,
    this.activities = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'moodType': moodType.index,
        'note': note,
        'dateTime': dateTime.toIso8601String(),
        'activities': activities,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        id: json['id'] as String,
        moodType: MoodType.values[json['moodType'] as int],
        note: json['note'] as String?,
        dateTime: DateTime.parse(json['dateTime'] as String),
        activities: List<String>.from(json['activities'] as List),
      );

  MoodEntry copyWith({
    String? id,
    MoodType? moodType,
    String? note,
    DateTime? dateTime,
    List<String>? activities,
  }) =>
      MoodEntry(
        id: id ?? this.id,
        moodType: moodType ?? this.moodType,
        note: note ?? this.note,
        dateTime: dateTime ?? this.dateTime,
        activities: activities ?? this.activities,
      );
}

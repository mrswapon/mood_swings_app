import 'package:flutter/material.dart';

enum MoodType {
  verySad,
  sad,
  neutral,
  happy,
  veryHappy,
}

extension MoodTypeExtension on MoodType {
  String get label => switch (this) {
        MoodType.verySad => 'Very Sad',
        MoodType.sad => 'Sad',
        MoodType.neutral => 'Neutral',
        MoodType.happy => 'Happy',
        MoodType.veryHappy => 'Very Happy',
      };

  String get emoji => switch (this) {
        MoodType.verySad => '\u{1F622}',
        MoodType.sad => '\u{1F614}',
        MoodType.neutral => '\u{1F610}',
        MoodType.happy => '\u{1F60A}',
        MoodType.veryHappy => '\u{1F604}',
      };

  int get numericValue => index + 1;

  Color get color => switch (this) {
        MoodType.verySad => const Color(0xFFE57373),
        MoodType.sad => const Color(0xFFFFB74D),
        MoodType.neutral => const Color(0xFFFFD54F),
        MoodType.happy => const Color(0xFF81C784),
        MoodType.veryHappy => const Color(0xFF64B5F6),
      };
}

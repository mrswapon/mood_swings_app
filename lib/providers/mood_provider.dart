import 'package:flutter/foundation.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/models/mood_entry.dart';
import 'package:mood_swings_app/services/storage_service.dart';
import 'package:mood_swings_app/utils/date_utils.dart';

class MoodProvider extends ChangeNotifier {
  final StorageService _storage;
  List<MoodEntry> _entries = [];
  bool _isLoading = true;

  MoodProvider(this._storage);

  List<MoodEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  MoodEntry? get todayEntry {
    final now = DateTime.now();
    for (final entry in _entries) {
      if (AppDateUtils.isSameDay(entry.dateTime, now)) return entry;
    }
    return null;
  }

  List<MoodEntry> get recentEntries => _entries.take(7).toList();

  List<MoodEntry> entriesForDate(DateTime date) {
    return _entries
        .where((e) => AppDateUtils.isSameDay(e.dateTime, date))
        .toList();
  }

  List<MoodEntry> entriesInRange(DateTime start, DateTime end) {
    return _entries
        .where((e) =>
            (e.dateTime.isAfter(start) || AppDateUtils.isSameDay(e.dateTime, start)) &&
            (e.dateTime.isBefore(end) || AppDateUtils.isSameDay(e.dateTime, end)))
        .toList();
  }

  /// Map of date (time stripped) -> dominant mood for that day (last entry of the day)
  Map<DateTime, MoodType> get dailyMoodMap {
    final map = <DateTime, MoodType>{};
    //=======================> entries are sorted newest first, so later entries overwrite earlier <=============
    for (final entry in _entries.reversed) {
      map[AppDateUtils.stripTime(entry.dateTime)] = entry.moodType;
    }
    return map;
  }

  MoodType? get mostCommonMood {
    if (_entries.isEmpty) return null;
    final counts = moodDistribution;
    MoodType? best;
    int bestCount = 0;
    for (final entry in counts.entries) {
      if (entry.value > bestCount) {
        bestCount = entry.value;
        best = entry.key;
      }
    }
    return best;
  }

  Map<MoodType, int> get moodDistribution {
    final counts = <MoodType, int>{};
    for (final entry in _entries) {
      counts[entry.moodType] = (counts[entry.moodType] ?? 0) + 1;
    }
    return counts;
  }

  /// Average mood per day for the last N days, returned as (date, average) pairs.
  List<MapEntry<DateTime, double>> dailyAverages(int days) {
    final now = DateTime.now();
    final result = <MapEntry<DateTime, double>>[];
    for (int i = days - 1; i >= 0; i--) {
      final date = AppDateUtils.stripTime(now.subtract(Duration(days: i)));
      final dayEntries = entriesForDate(date);
      if (dayEntries.isNotEmpty) {
        final avg = dayEntries
                .map((e) => e.moodType.numericValue)
                .reduce((a, b) => a + b) /
            dayEntries.length;
        result.add(MapEntry(date, avg));
      }
    }
    return result;
  }

  int get currentStreak {
    if (_entries.isEmpty) return 0;
    int streak = 0;
    var checkDate = AppDateUtils.stripTime(DateTime.now());
    while (true) {
      final hasEntry =
          _entries.any((e) => AppDateUtils.isSameDay(e.dateTime, checkDate));
      if (!hasEntry) break;
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }

  //=======================> CRUD <=============

  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();
    _entries = await _storage.loadEntries();
    _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(MoodEntry entry) async {
    _entries.insert(0, entry);
    _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    await _storage.saveEntries(_entries);
    notifyListeners();
  }

  Future<void> updateEntry(MoodEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      await _storage.saveEntries(_entries);
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _storage.saveEntries(_entries);
    notifyListeners();
  }

  Future<void> clearAll() async {
    _entries.clear();
    await _storage.clearEntries();
    notifyListeners();
  }
}

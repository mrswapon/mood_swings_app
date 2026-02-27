import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';

class MoodPieChart extends StatefulWidget {
  final Map<MoodType, int> distribution;

  const MoodPieChart({super.key, required this.distribution});

  @override
  State<MoodPieChart> createState() => _MoodPieChartState();
}

class _MoodPieChartState extends State<MoodPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.distribution.values.fold(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _buildSections(total),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.distribution.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: entry.key.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.key.emoji} ${entry.value}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    int index = 0;
    return widget.distribution.entries.map((entry) {
      final isTouched = index == _touchedIndex;
      final percentage = (entry.value / total * 100).toStringAsFixed(0);
      final section = PieChartSectionData(
        color: entry.key.color,
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: isTouched ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Text(entry.key.emoji, style: const TextStyle(fontSize: 20))
            : null,
        badgePositionPercentageOffset: 1.2,
      );
      index++;
      return section;
    }).toList();
  }
}

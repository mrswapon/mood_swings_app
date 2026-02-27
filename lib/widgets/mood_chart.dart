import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/utils/date_utils.dart';

class MoodChart extends StatelessWidget {
  final List<MapEntry<DateTime, double>> data;

  const MoodChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].value));
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16),
        child: LineChart(
          LineChartData(
            minY: 0.5,
            maxY: 5.5,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
              ),
              drawVerticalLine: false,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    final intVal = value.toInt();
                    if (intVal < 1 || intVal > 5) {
                      return const SizedBox.shrink();
                    }
                    final mood = MoodType.values[intVal - 1];
                    return Text(
                      mood.emoji,
                      style: const TextStyle(fontSize: 14),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= data.length) {
                      return const SizedBox.shrink();
                    }
                    // Show every other label if too many points
                    if (data.length > 7 && index % 2 != 0) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        AppDateUtils.formatDayMonth(data[index].key),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    final moodIndex = spot.y.round() - 1;
                    final color = moodIndex >= 0 && moodIndex < MoodType.values.length
                        ? MoodType.values[moodIndex].color
                        : Colors.grey;
                    return FlDotCirclePainter(
                      radius: 5,
                      color: color,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final moodIndex = spot.y.round() - 1;
                    final mood = moodIndex >= 0 && moodIndex < MoodType.values.length
                        ? MoodType.values[moodIndex]
                        : null;
                    final dateStr = index >= 0 && index < data.length
                        ? AppDateUtils.formatDayMonth(data[index].key)
                        : '';
                    return LineTooltipItem(
                      '${mood?.emoji ?? ''} ${mood?.label ?? ''}\n$dateStr',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

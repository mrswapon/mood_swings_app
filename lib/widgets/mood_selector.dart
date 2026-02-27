import 'package:flutter/material.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';

class MoodSelector extends StatelessWidget {
  final MoodType? selected;
  final ValueChanged<MoodType> onSelected;

  const MoodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodType.values.map((mood) {
        final isSelected = selected == mood;
        return GestureDetector(
          onTap: () => onSelected(mood),
          child: AnimatedScale(
            scale: isSelected ? 1.3 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? mood.color.withValues(alpha: 0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected ? mood.color : Colors.grey.shade300,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mood.emoji,
                    style: const TextStyle(fontSize: 32),
                    semanticsLabel: mood.label,
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isSelected ? 11 : 10,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? mood.color
                          : Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color ?? Colors.grey,
                    ),
                    child: Text(mood.label),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

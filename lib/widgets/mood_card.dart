import 'package:flutter/material.dart';
import 'package:mood_swings_app/constants/mood_constants.dart';
import 'package:mood_swings_app/models/mood_entry.dart';
import 'package:mood_swings_app/theme/app_colors.dart';
import 'package:mood_swings_app/utils/date_utils.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MoodCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  void _showDetailDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Mood Detail',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _MoodDetailDialog(
          entry: entry,
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border.all(
          color: entry.moodType.color.withValues(alpha: isDark ? 0.25 : 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetailDialog(context),
          borderRadius: BorderRadius.circular(18),
          splashColor: entry.moodType.color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=======================> Emoji with glow ring <=============
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        entry.moodType.color.withValues(alpha: 0.25),
                        entry.moodType.color.withValues(alpha: 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: entry.moodType.color.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.moodType.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                //=======================> Content <=============
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.moodType.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (onEdit != null || onDelete != null)
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              onSelected: (value) {
                                if (value == 'edit') onEdit?.call();
                                if (value == 'delete') onDelete?.call();
                              },
                              itemBuilder: (context) => [
                                if (onEdit != null)
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_rounded, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                if (onDelete != null)
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_rounded,
                                            size: 18, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppDateUtils.formatFull(entry.dateTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      if (entry.note != null && entry.note!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          entry.note!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      if (entry.activities.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: entry.activities
                              .take(3)
                              .map((a) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: entry.moodType.color
                                          .withValues(alpha: 0.12),
                                    ),
                                    child: Text(
                                      a,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: entry.moodType.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList()
                            ..addAll(
                              entry.activities.length > 3
                                  ? [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey.withValues(alpha: 0.12),
                                        ),
                                        child: Text(
                                          '+${entry.activities.length - 3}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
//=======================> Detail Dialog <=============
// ──────────────────────────────────────────────────────────

class _MoodDetailDialog extends StatefulWidget {
  final MoodEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MoodDetailDialog({
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<_MoodDetailDialog> createState() => _MoodDetailDialogState();
}

class _MoodDetailDialogState extends State<_MoodDetailDialog>
    with TickerProviderStateMixin {
  late AnimationController _emojiController;
  late AnimationController _contentController;
  late Animation<double> _emojiBounce;
  late Animation<double> _contentSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _emojiBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.15), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _emojiController, curve: Curves.easeOut),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _contentSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
          parent: _contentController, curve: Curves.easeOutCubic),
    );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _emojiController.forward();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodColor = widget.entry.moodType.color;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.88,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: moodColor.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //=======================> Header <=============
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  child: Column(
                    children: [
                      //=======================> Emoji with bounce <=============
                      ScaleTransition(
                        scale: _emojiBounce,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.black26
                                : Colors.white.withValues(alpha: 0.7),
                            border: Border.all(
                              color: moodColor.withValues(alpha: 0.5),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: moodColor.withValues(alpha: 0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.entry.moodType.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      //=======================> Mood label <=============
                      Text(
                        widget.entry.moodType.label,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: moodColor,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 6),
                      //=======================> Date/time <=============
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: moodColor.withValues(alpha: 0.12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 14, color: moodColor),
                            const SizedBox(width: 6),
                            Text(
                              AppDateUtils.formatFull(widget.entry.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: moodColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //=======================> Content body <=============
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _contentSlide.value),
                      child: Opacity(
                        opacity: _contentFade.value,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //=======================> Note section <=============
                        if (widget.entry.note != null &&
                            widget.entry.note!.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.notes_rounded,
                                  size: 16, color: moodColor),
                              const SizedBox(width: 8),
                              Text(
                                'Note',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: moodColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade50,
                              border: Border.all(
                                color: isDark
                                    ? Colors.white12
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Text(
                              widget.entry.note!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        //=======================> Activities section <=============
                        if (widget.entry.activities.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.category_rounded,
                                  size: 16, color: moodColor),
                              const SizedBox(width: 8),
                              Text(
                                'Activities',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: moodColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.entry.activities
                                .map((a) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 7),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        gradient: LinearGradient(
                                          colors: [
                                            moodColor.withValues(alpha: 0.15),
                                            moodColor.withValues(alpha: 0.06),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: moodColor
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Text(
                                        a,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: moodColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                        ],

                        //=======================> No note & no activities <=============
                        if ((widget.entry.note == null ||
                                widget.entry.note!.isEmpty) &&
                            widget.entry.activities.isEmpty) ...[
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'No additional details',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),

                //=======================> Action buttons <=============
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Row(
                    children: [
                      if (widget.onDelete != null)
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onDelete?.call();
                            },
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 18),
                            label: const Text('Delete'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade400,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                    color:
                                        Colors.red.shade200.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                        ),
                      if (widget.onDelete != null && widget.onEdit != null)
                        const SizedBox(width: 10),
                      if (widget.onEdit != null)
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onEdit?.call();
                            },
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text('Edit Entry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: moodColor,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      if (widget.onEdit == null && widget.onDelete == null)
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Close'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

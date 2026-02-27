import 'package:flutter/material.dart';

class StatSummaryCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const StatSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.delay = 0,
  });

  @override
  State<StatSummaryCard> createState() => _StatSummaryCardState();
}

class _StatSummaryCardState extends State<StatSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _iconBounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _iconBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xFF16213E) : Colors.white,
          border: Border.all(
            color: widget.color.withValues(alpha: isDark ? 0.3 : 0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //=======================> Icon with glow <=============
              AnimatedBuilder(
                animation: _iconBounceAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconBounceAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: isDark ? 0.3 : 0.18),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              //=======================> Value <=============
              Text(
                widget.value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                      fontSize: 15,
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              //=======================> Divider accent <=============
              Container(
                width: 24,
                height: 2.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.color.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 8),

              //=======================> Title <=============
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? Colors.white70
                          : Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

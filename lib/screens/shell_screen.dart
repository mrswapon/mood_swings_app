import 'package:flutter/material.dart';
import 'package:mood_swings_app/screens/calendar/calendar_screen.dart';
import 'package:mood_swings_app/screens/entry/mood_entry_screen.dart';
import 'package:mood_swings_app/screens/home/home_screen.dart';
import 'package:mood_swings_app/screens/settings/settings_screen.dart';
import 'package:mood_swings_app/screens/stats/stats_screen.dart';
import 'package:mood_swings_app/theme/app_colors.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _fabController;
  late final AnimationController _navController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  final List<Widget> _screens = const [
    HomeScreen(),
    CalendarScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    //=======================> Page transition animations <=============
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    //=======================> FAB animations <=============
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );
    _fabRotationAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
    );

    //=======================> Nav bar entrance <=============
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    //=======================> Play initial entrance animations <=============
    _fadeController.forward();
    _slideController.forward();
    _fabController.forward();
    _navController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _fabController.dispose();
    _navController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });

    //=======================> Determine slide direction based on tab position <=============
    final goingRight = index > _previousIndex;
    _slideAnimation =
        Tween<Offset>(
          begin: Offset(goingRight ? 0.04 : -0.04, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();

    //=======================> Bounce the FAB on tab switch <=============
    _fabController.reset();
    _fabController.forward();
  }

  void _openMoodEntry() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MoodEntryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideUp =
              Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          final fade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(
            position: slideUp,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: IndexedStack(index: _currentIndex, children: _screens),
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _navController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: _AnimatedNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: RotationTransition(
          turns: _fabRotationAnimation,
          child: FloatingActionButton(
            onPressed: _openMoodEntry,
            elevation: 6,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AnimatedNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home, label: 'Home'),
    _NavItem(
      icon: Icons.calendar_month_rounded,
      activeIcon: Icons.calendar_month,
      label: 'Calendar',
    ),
    _NavItem(
      icon: Icons.bar_chart_rounded,
      activeIcon: Icons.bar_chart,
      label: 'Stats',
    ),
    _NavItem(
      icon: Icons.settings_rounded,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              return _AnimatedNavItem(
                icon: isActive ? item.activeIcon : item.icon,
                label: item.label,
                isActive: isActive,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
        );
  }

  @override
  void didUpdateWidget(covariant _AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: widget.isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _bounceAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  key: ValueKey(widget.isActive),
                  size: 24,
                  color: widget.isActive
                      ? AppColors.primary
                      : Colors.grey.shade500,
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: widget.isActive
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.isActive ? 1.0 : 0.0,
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

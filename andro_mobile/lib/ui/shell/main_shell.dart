import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../theme_colors.dart';
import '../home/home_feed_page.dart';
import '../explore/explore_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  int _unreadNotifications = 2;

  void _onTabTapped(int pageIndex) {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = pageIndex);
  }

  void _onNotifTapped() {
    if (_unreadNotifications > 0) setState(() => _unreadNotifications = 0);
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = 2);
  }

  void _onProfileTapped() {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = 3);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final themeMode = appState.themeMode;
    final isDark = themeMode == ThemeMode.dark;
    final currentUser = appState.currentUser;

    final bg    = isDark ? AndroColors.darkBackground : AndroColors.lightBackground;
    final navBg = isDark ? AndroColors.darkNavBg      : AndroColors.lightNavBg;
    final amber = isDark ? AndroColors.darkAmber       : AndroColors.lightAmber;
    final grey  = isDark ? AndroColors.darkSecondary   : AndroColors.lightSecondary;

    final pages = [
      HomeFeedPage(
        themeMode: themeMode,
        onToggleTheme: appState.toggleTheme,
        currentUser: {'name': currentUser.name, 'email': currentUser.email},
        onNotificationsTap: _onNotifTapped,
      ),
      ExplorePage(
        themeMode: themeMode,
        onToggleTheme: appState.toggleTheme,
      ),
      NotificationsPage(
        themeMode: themeMode,
        onToggleTheme: appState.toggleTheme,
      ),
      ProfileScreen(userId: currentUser.id),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: _buildNavBar(navBg, amber, grey, isDark),
    );
  }

  Widget _buildNavBar(Color navBg, Color amber, Color grey, bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          top: BorderSide(
            color: isDark ? AndroColors.darkDivider : AndroColors.lightDivider,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            iconOutline: Icons.home_outlined,
            label: 'Home',
            isActive: _currentIndex == 0,
            activeColor: amber,
            inactiveColor: grey,
            onTap: () => _onTabTapped(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            iconOutline: Icons.search_outlined,
            label: 'Explore',
            isActive: _currentIndex == 1,
            activeColor: amber,
            inactiveColor: grey,
            onTap: () => _onTabTapped(1),
          ),
          // Centre FAB
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Create new post'),
                  backgroundColor: isDark
                      ? AndroColors.darkAccent
                      : AndroColors.lightAccent,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: amber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: amber.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notifications
          Stack(
            clipBehavior: Clip.none,
            children: [
              _NavItem(
                icon: Icons.notifications_rounded,
                iconOutline: Icons.notifications_outlined,
                label: 'Notifs',
                isActive: _currentIndex == 2,
                activeColor: amber,
                inactiveColor: grey,
                onTap: _onNotifTapped,
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  top: 6,
                  right: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          _NavItem(
            icon: Icons.person_rounded,
            iconOutline: Icons.person_outlined,
            label: 'Profile',
            isActive: _currentIndex == 3,
            activeColor: amber,
            inactiveColor: grey,
            onTap: _onProfileTapped,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconOutline;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconOutline,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? icon : iconOutline,
                key: ValueKey(isActive),
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

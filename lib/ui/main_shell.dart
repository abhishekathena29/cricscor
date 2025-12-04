import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/navigation/bottom_navigation_bar.dart';

import 'home/home_screen.dart';
import 'my_cricket/my_cricket_screen.dart';
import 'profile/profile_screen.dart';
import 'stats/stats_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeScreen(),
      MyCricketScreen(),
      StatsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        tabs: _tabItems(context),
        builder: (context, onTabTap) {
          _onTabChange = onTabTap;
        },
      ),
    );
  }

  void _changeTab(int index) {
    _pageController.jumpToPage(index);
    _onTabChange?.call(index);
  }

  List<TabItem> _tabItems(BuildContext context) {
    return [
      _tabItem(
        context,
        label: 'Home',
        iconPath: 'assets/images/ic_home.svg',
        onTap: () => _changeTab(0),
      ),
      _tabItem(
        context,
        label: 'My Cricket',
        iconPath: 'assets/images/ic_cricket.svg',
        onTap: () => _changeTab(1),
      ),
      _tabItem(
        context,
        label: 'Stats',
        iconPath: 'assets/images/ic_stats.svg',
        onTap: () => _changeTab(2),
      ),
      _tabItem(
        context,
        label: 'Profile',
        iconPath: 'assets/images/ic_profile.svg',
        onTap: () => _changeTab(3),
      ),
    ];
  }

  void Function(int)? _onTabChange;

  Widget _navIcon(
    BuildContext context, {
    required String asset,
    bool isActive = false,
  }) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? context.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SvgPicture.asset(
        asset,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          isActive
              ? context.colorScheme.onPrimary
              : context.colorScheme.textDisabled,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  TabItem _tabItem(
    BuildContext context, {
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return TabItem(
      tabIcon: _navIcon(context, asset: iconPath),
      tabActiveIcon: _navIcon(context, asset: iconPath, isActive: true),
      tabLabel: label,
      route: '',
      onTap: onTap,
    );
  }
}

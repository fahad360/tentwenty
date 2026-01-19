import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'features/watch/watch_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Watch tab based on request context

  final List<Widget> _screens = [
    const Center(child: Text('Dashboard')),
    const WatchScreen(),
    const Center(child: Text('Media Library')),
    const Center(child: Text('More')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
          ),
          color: Color(0xFF2E2739),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(27),
            topRight: Radius.circular(27),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFF2E2739),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color(0xFF827D88),
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              _buildNavItem('assets/svgs/dashboard.svg', 'Dashboard'),
              _buildNavItem('assets/svgs/watch.svg', 'Watch'),
              _buildNavItem('assets/svgs/media_library.svg', 'Media Library'),
              _buildNavItem('assets/svgs/more.svg', 'More'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: SvgPicture.asset(
          assetName,
          colorFilter: const ColorFilter.mode(
            Color(0xFF827D88),
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: SvgPicture.asset(
          assetName,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      label: label,
    );
  }
}

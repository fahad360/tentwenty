import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tentwenty/features/media_library/presentation/pages/media_library_screen.dart';
import '../../../../features/watch/presentation/pages/watch_screen.dart';
import '../cubit/bottom_nav_cubit.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: const BottomNavView(),
    );
  }
}

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final List<Widget> _screens = const [
    Center(child: Text('Dashboard')),
    WatchScreen(),
    MediaLibraryScreen(),
    Center(child: Text('More')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(index: state.index, children: _screens),
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
                currentIndex: state.index,
                onTap: (index) {
                  context.read<BottomNavCubit>().changeIndex(index);
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
                  _buildNavItem(
                    'assets/svgs/media_library.svg',
                    'Media Library',
                  ),
                  _buildNavItem('assets/svgs/more.svg', 'More'),
                ],
              ),
            ),
          ),
        );
      },
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

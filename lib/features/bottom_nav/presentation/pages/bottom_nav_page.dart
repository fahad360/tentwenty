import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tentwenty/features/media_library/presentation/pages/media_library_screen.dart';
import '../../../../features/watch/presentation/pages/watch_screen.dart';
import '../cubit/bottom_nav_cubit.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

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
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }
}

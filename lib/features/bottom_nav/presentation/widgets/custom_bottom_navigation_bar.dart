import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/colors.dart';
import '../cubit/bottom_nav_cubit.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
            ),
            color: AppColors.darkPurple,
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
              backgroundColor: AppColors.darkPurple,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.white,
              unselectedItemColor: AppColors.greyText,
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
            AppColors.greyText,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
        child: SvgPicture.asset(
          assetName,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
      label: label,
    );
  }
}

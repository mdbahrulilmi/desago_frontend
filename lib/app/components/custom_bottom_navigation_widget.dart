import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar
    extends GetView<BottomNavigationController> {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildNavItem(index: 0)),
                Expanded(child: _buildNavItem(index: 1)),
                const SizedBox(width: 80),
                Expanded(child: _buildNavItem(index: 2)),
                Expanded(child: _buildNavItem(index: 3)),
              ],
            ),
          ),
        ),

        /// FLOATING LAPOR BUTTON
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                elevation: 8,
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.white, width: 2),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: controller.navigateToLapor,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/navigation/report.svg',
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Lapor',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// SINGLE NAV ITEM
  Widget _buildNavItem({required int index}) {
    return Obx(() {
      final bool isActive = controller.isActive(index);

      return InkWell(
        onTap: () => controller.changePage(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _navIcon(index, isActive),
            const SizedBox(height: 4),
            Text(
              controller.pageNames[index],
              style: isActive
                  ? AppText.smallBold(color: Colors.white)
                  : AppText.small(color: Colors.black),
            ),
          ],
        ),
      );
    });
  }

  Widget _navIcon(int index, bool isActive) {
    switch (index) {
      case 0:
        return SvgPicture.asset(
          isActive
              ? 'assets/icons/navigation/home_active.svg'
              : 'assets/icons/navigation/home.svg',
          width: 28,
        );
      case 1:
        return SvgPicture.asset(
          isActive
              ? 'assets/icons/navigation/letter_active.svg'
              : 'assets/icons/navigation/letter.svg',
          width: 28,
        );
      case 2:
        return SvgPicture.asset(
          isActive
              ? 'assets/icons/navigation/activity_active.svg'
              : 'assets/icons/navigation/activity.svg',
          width: 28,
        );
      case 3:
        return SvgPicture.asset(
          isActive
              ? 'assets/icons/navigation/account_active.svg'
              : 'assets/icons/navigation/account.svg',
          width: 28,
        );
      default:
        return const SizedBox();
    }
  }
}

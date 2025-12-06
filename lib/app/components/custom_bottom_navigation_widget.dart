import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class CustomBottomNavigationBar extends GetView<BottomNavigationController> {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.muted.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 0,
                    route: controller.indexToRoute[0],
                    label: controller.pageNames[0],
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 1,
                    route: controller.indexToRoute[1],
                    label: controller.pageNames[1],
                  ),
                ),
                SizedBox(width: 60),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 2,
                    route: controller.indexToRoute[2],
                    label: controller.pageNames[2],
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    index: 3,
                    route: controller.indexToRoute[3],
                    label: controller.pageNames[3],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.LAPOR);
                  },
                  customBorder: CircleBorder(),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.danger,
                          AppColors.purple,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.danger.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Remix.alarm_warning_fill,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String route,
    required String label,
  }) {
    IconData getRemixIcon(String route, bool isActive) {
      switch (route) {
        case Routes.HOME:
          return isActive ? Remix.home_3_fill : Remix.home_3_line;
        case Routes.SURAT_PETUNJUK:
          return isActive ? Remix.mail_ai_fill : Remix.mail_ai_line;
        case Routes.BERITA_LIST:
          return isActive ? Remix.newspaper_fill : Remix.newspaper_line;
        case Routes.AKUN:
          return isActive ? Remix.user_2_fill : Remix.user_2_line;
        default:
          return isActive ? Remix.file_fill : Remix.file_line;
      }
    }

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return InkWell(
        onTap: () => controller.changePage(index),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                getRemixIcon(route, isSelected),
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: isSelected
                    ? AppText.smallBold(color: Colors.white)
                    : AppText.small(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}

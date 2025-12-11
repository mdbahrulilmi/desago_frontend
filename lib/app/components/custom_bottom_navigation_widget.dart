import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomBottomNavigationBar extends GetView<BottomNavigationController> {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
        ),
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
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
                        AppColors.white,
                        AppColors.white,
                      ],
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/navigation/report.svg')
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String route,
    required String label,
  }) {

    Widget ImageIcon(String route, bool isActive){
       switch (route) {
        case Routes.HOME:
          return SvgPicture.asset(
    isActive
        ? 'assets/icons/navigation/home_active.svg'
        : 'assets/icons/navigation/home.svg',
    width: 24,
    height: 24,
  );
        case Routes.SURAT_PETUNJUK:
          return SvgPicture.asset(
    isActive
        ? 'assets/icons/navigation/letter_active.svg'
        : 'assets/icons/navigation/letter.svg',
    width: 24,
    height: 24,
  );
        case Routes.BERITA_LIST:
          return SvgPicture.asset(
    isActive
        ? 'assets/icons/navigation/activity_active.svg'
        : 'assets/icons/navigation/activity.svg',
    width: 24,
    height: 24,
  );
        case Routes.AKUN:
          return SvgPicture.asset(
    isActive
        ? 'assets/icons/navigation/account_active.svg'
        : 'assets/icons/navigation/account.svg',
    width: 24,
    height: 24,
  );
        default:
        return SvgPicture.asset(
    isActive
        ? 'assets/icons/navigation/home.svg'
        : 'assets/icons/navigation/home.svg',
    width: 24,
    height: 24,
  );
    }}

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
              ImageIcon(route, isSelected),
              SizedBox(height: 4),
              Text(
                label,
                style: isSelected
                    ? AppText.smallBold(color: Colors.white)
                    : AppText.small(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}

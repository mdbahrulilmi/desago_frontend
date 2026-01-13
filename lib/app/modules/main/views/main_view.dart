import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
import 'package:desago/app/modules/aktivitas/views/aktivitas_view.dart';
import 'package:desago/app/modules/akun/views/akun_view.dart';
import 'package:desago/app/modules/berita_list/views/berita_list_view.dart';
import 'package:desago/app/modules/home/views/home_view.dart';
import 'package:desago/app/modules/surat_petunjuk/views/surat_petunjuk_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<BottomNavigationController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: controller.selectedIndex.value,
              children: const [
                HomeView(),
                SuratPetunjukView(),
                AktivitasView(),
                AkunView(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigationBar(),
            ),
          ],
        ),
      );
    });
  }
}



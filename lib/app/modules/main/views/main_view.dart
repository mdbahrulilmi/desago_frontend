import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
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
        extendBody: true,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeView(),
            SuratPetunjukView(),
            BeritaListView(),
            AkunView(),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      );
    });
  }
}


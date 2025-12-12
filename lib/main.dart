import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_links/app_links.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  Get.put(BottomNavigationController());

  // ============================
  // 🔥 APP LINKS START
  // ============================
  final appLinks = AppLinks();

  // Listen saat app sudah running
  appLinks.uriLinkStream.listen((uri) {
    if (uri != null && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'] ?? '';
      final email = uri.queryParameters['email'] ?? '';
      Get.toNamed('/password-baru', arguments: {'token': token, 'email': email});
    }
  });

  // Tangkap initial link saat cold start
  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null && initialUri.path == '/reset-password') {
    final token = initialUri.queryParameters['token'] ?? '';
    final email = initialUri.queryParameters['email'] ?? '';
    Future.microtask(() {
      Get.toNamed('/password-baru', arguments: {'token': token, 'email': email});
    });
  }


  // ============================
  // 🔥 APP LINKS END
  // ============================

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initialRoute = AppPages.getInitialRoute();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}

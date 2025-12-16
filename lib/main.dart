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

  final appLinks = AppLinks();
  final Uri? initialUri = await appLinks.getInitialLink();
  print('🔥 INITIAL URI: $initialUri');

  String initialRoute = AppPages.getInitialRoute();
  Map<String, String>? initialParams;

  if (initialUri != null && initialUri.path == '/reset-password') {
    initialRoute = '/password-baru';
    initialParams = {
      'token': initialUri.queryParameters['token'] ?? '',
      'email': initialUri.queryParameters['email'] ?? '',
    };
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    initialParams: initialParams,
    appLinks: appLinks,
  ));
}

// =================================================
// 🔥 SINGLE APP
// =================================================
class MyApp extends StatefulWidget {
  final String initialRoute;
  final Map<String, String>? initialParams;
  final AppLinks appLinks;

  const MyApp({
    super.key,
    required this.initialRoute,
    required this.appLinks,
    this.initialParams,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// 🔥 DEEP LINK SAAT APP RUNNING / BACKGROUND
    widget.appLinks.uriLinkStream.listen((uri) {
      if (uri.path == '/reset-password') {
        Get.offAllNamed(
          '/password-baru',
          parameters: {
            'token': uri.queryParameters['token'] ?? '',
            'email': uri.queryParameters['email'] ?? '',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      initialRoute: widget.initialRoute,
      initialBinding: BindingsBuilder(() {
        if (widget.initialParams != null) {
          Get.parameters.addAll(widget.initialParams!);
        }
      }),
      getPages: AppPages.routes,
    );
  }
}

import 'package:desago/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_links/app_links.dart';
import 'package:desago/firebase_options.dart';
import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
  
  Get.put(AuthController(), permanent: true);
  Get.put(BottomNavigationController());

  final appLinks = AppLinks();
  String initialRoute = AppPages.getInitialRoute(); 
  Map<String, String>? initialArgs;

  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null && initialUri.path == '/reset-password') {
    initialRoute = '/password-baru';
    initialArgs = {
      'token': initialUri.queryParameters['token'] ?? '',
      'email': initialUri.queryParameters['email'] ?? '',
    };
  }
  runApp(MyApp(
    initialRoute: initialRoute,
    initialArgs: initialArgs,
  ));

  appLinks.uriLinkStream.listen((uri) {
    if (uri != null && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'] ?? '';
      final email = uri.queryParameters['email'] ?? '';
      print('>>> Running deep link detected: token=$token, email=$email');
      Get.toNamed('/password-baru', arguments: {'token': token, 'email': email});
    }
  });
  
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, String>? initialArgs;

  const MyApp({super.key, required this.initialRoute, this.initialArgs});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Desago App",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        if (initialArgs != null) {
          Get.parameters.addAll(initialArgs!);
        }
      }),
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => Scaffold  (
          body: Center(child: Text('Halaman tidak ditemukan')),
        ),
      ),
      routingCallback: (info) {
        print('>>> Navigasi ke route: ${info?.current}');
      },
    );
  }
}
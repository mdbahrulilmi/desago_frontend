import 'package:desago/app/controllers/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    _handleNotificationClick(initialMessage);
  }

  await messaging.requestPermission();
  String? token = await messaging.getToken();
  print("FCM Token: $token");

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

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleNotificationClick(message);
  });

  runApp(MyApp(
    initialRoute: initialRoute,
    initialArgs: initialArgs,
  ));

  appLinks.uriLinkStream.listen((uri) {
    if (uri != null && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'] ?? '';
      final email = uri.queryParameters['email'] ?? '';
      Get.toNamed('/password-baru', arguments: {'token': token, 'email': email});
    }
  });
  
}

void _handleNotificationClick(RemoteMessage message) {
  final data = message.data;

  print("DATA FCM: $data");

  // 🔥 PRIORITAS: ambil dari link
  if (data.containsKey('link')) {
    final link = data['link'];

    if (link.startsWith("surat/")) {
      final id = link.split("/")[1];
      print("OPEN SURAT ID: $id");
      Get.toNamed(
        '/surat-riwayat-pengajuan-detail',
        arguments: {'id': id},
      );
      return;
    }

    if (link.startsWith("lapor/")) {
      final id = link.split("/")[1];
      print("OPEN LAPOR ID: $id");
      Get.toNamed(
        '/lapor-detail',
        arguments: {'id': id},
      );
      return;
    }

    if (link.startsWith("agenda/")) {
      final id = link.split("/")[1];
      print("OPEN AGENDA ID: $id");
      Get.toNamed(
        '/agenda',
        arguments: {'id': id},
      );
      return;
    }
  }

  // fallback kalau tidak ada link
  if (data['type'] == 'surat' && data['id'] != null) {
    print("FALLBACK SURAT ID: ${data['id']}");
    Get.toNamed(
      '/surat-detail',
      arguments: {'id': data['id']},
    );
    return;
  }

  if (data['type'] == 'lapor' && data['id'] != null) {
    print("FALLBACK LAPOR ID: ${data['id']}");
    Get.toNamed(
      '/lapor-detail',
      arguments: {'id': data['id']},
    );
    return;
  }

  // fallback terakhir: kalau tidak ada yang cocok buka halaman depan
  print("NO LINK / TYPE MATCH - OPEN HOMEPAGE");
  Get.toNamed('/home');
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
      },
    );
  }
}
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
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();
  String? token = await messaging.getToken();

  await initializeDateFormatting('id_ID', null);

  // Controller
  Get.put(AuthController(), permanent: true);
  Get.put(BottomNavigationController());

  final appLinks = AppLinks();
  String initialRoute = AppPages.getInitialRoute(); 
  Map<String, String>? initialArgs;

  // Tangani deep link awal
  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null && initialUri.path == '/reset-password') {
    initialRoute = '/password-baru';
    initialArgs = {
      'token': initialUri.queryParameters['token'] ?? '',
      'email': initialUri.queryParameters['email'] ?? '',
    };
  }

  // Tangani notifikasi awal
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  Map<String, dynamic>? initialNotificationData;
  if (initialMessage != null) {
    initialNotificationData = initialMessage.data;
  }

  // Jalankan app
  runApp(MyApp(
    initialRoute: initialRoute,
    initialArgs: initialArgs,
    initialNotificationData: initialNotificationData,
  ));

  // Notifikasi saat app sedang running
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNotificationClick(message.data);
    });
  });

  // Deep link saat app sedang running
  appLinks.uriLinkStream.listen((uri) {
    if (uri != null && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'] ?? '';
      final email = uri.queryParameters['email'] ?? '';
      Get.toNamed('/password-baru', arguments: {'token': token, 'email': email});
    }
  });
}

// Fungsi global untuk navigasi dari notifikasi
void _handleNotificationClick(Map<String, dynamic> data) {
  if (data.containsKey('link')) {
    final link = data['link'];

    if (link.startsWith("surat/")) {
      final id = link.split("/")[1];
      Get.offAllNamed('/surat-riwayat-pengajuan-detail', arguments: {'id': id});
      return;
    }

    if (link.startsWith("lapor/")) {
      final id = link.split("/")[1];
      Get.offAllNamed('/lapor-detail', arguments: {'id': id});
      return;
    }

    if (link.startsWith("agenda/")) {
      final id = link.split("/")[1];
      Get.offAllNamed('/agenda', arguments: {'id': id});
      return;
    }

    if (link.startsWith("berita/")) {
      final id = link.split("/")[1];
      Get.offAllNamed('/berita-detail', arguments: {'id': id});
      return;
    }
  }

  if (data['type'] == 'surat' && data['id'] != null) {
    Get.offAllNamed('/surat-detail', arguments: {'id': data['id']});
    return;
  }

  if (data['type'] == 'lapor' && data['id'] != null) {
    Get.offAllNamed('/lapor-detail', arguments: {'id': data['id']});
    return;
  }

  if (data['type'] == 'berita' && data['id'] != null) {
    Get.offAllNamed('/berita-detail', arguments: {'id': data['id']});
    return;
  }

  Get.offAllNamed('/main');
}

// MyApp
class MyApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, String>? initialArgs;
  final Map<String, dynamic>? initialNotificationData;

  const MyApp({
    super.key,
    required this.initialRoute,
    this.initialArgs,
    this.initialNotificationData,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: "Desago App",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        if (initialArgs != null) {
          Get.parameters.addAll(initialArgs!);
        }

        // Navigasi dari notifikasi awal setelah frame pertama
        if (initialNotificationData != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleNotificationClick(initialNotificationData!);
          });
        }
      }),
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => Scaffold(
          body: Center(child: Text('Halaman tidak ditemukan')),
        ),
      ),
    );
  }
}
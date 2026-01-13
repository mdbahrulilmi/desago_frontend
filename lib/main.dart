  import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
  import 'package:desago/app/constant/api_constant.dart';
  import 'package:desago/app/services/dio_services.dart';
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

  String initialRoute = AppPages.getInitialRoute();
  Map<String, String>? initialParams;

  if (initialUri != null && initialUri.path == '/reset-password') {
    initialRoute = '/password-baru';
    initialParams = {
      'token': initialUri.queryParameters['token'] ?? '',
    };
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    initialParams: initialParams,
    appLinks: appLinks,
  ));
}

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
  bool _handledInitialLink = false;

  @override
  void initState() {
    super.initState();
    widget.appLinks.uriLinkStream.listen(_handleIncomingLink);
  }

  Future<void> _handleIncomingLink(Uri uri) async {
    if (uri.path != '/reset-password') return;
    if (_handledInitialLink) return;

    _handledInitialLink = true;

    final token = uri.queryParameters['email'];

    if (token == null || token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }

    try {
      final res = await DioService.instance.post(
        ApiConstant.tokenExpired,
        data: {'email': token},
      );

      final bool success = res.data['success'] == true;

      if (!success) {
        Get.offAllNamed('/login');
        return;
      }

      Get.offAllNamed(
        '/password-baru',
        parameters: {
          'token': token,
        },
      );
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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

import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/modules/berita_list/controllers/berita_list_controller.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null);

  Get.put(BottomNavigationController());

  String initialRoute = AppPages.getInitialRoute();

  Map<String, String>? initialParams;

  runApp(MyApp(
    initialRoute: initialRoute,
    initialParams: initialParams,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, String>? initialParams;

  const MyApp({
    super.key,
    required this.initialRoute,
    this.initialParams,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      initialBinding: BindingsBuilder(() {
        if (initialParams != null) {
          Get.parameters.addAll(initialParams!);
        }
      }),
      getPages: AppPages.routes,
    );
  }
}

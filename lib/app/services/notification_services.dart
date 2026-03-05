import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

/// Background handler (harus top-level function)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('Background notification clicked: ${response.payload}');
  // Navigasi halaman bisa dipanggil di sini kalau perlu
  // ex: Get.toNamed('/chat', arguments: response.payload);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi notification service
  static Future<void> initialize() async {
    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine settings
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print('Notifikasi diklik, payload: ${response.payload}');
          // Navigasi halaman contoh
          // Get.toNamed('/chat', arguments: response.payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request permission
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Listener foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message diterima: ${message.notification?.title}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showLocalNotification(notification, message.data);
      }
    });

    // Listener klik notifikasi dari background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User membuka notifikasi: ${message.notification?.title}');
      // Navigasi halaman contoh:
      // Get.toNamed('/chat', arguments: message.data);
    });

    // Handle app dibuka dari terminated notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          'App dibuka dari terminated notification: ${initialMessage.notification?.title}');
      // Navigasi halaman contoh:
      // Get.toNamed('/chat', arguments: initialMessage.data);
    }
  }

  /// Tampilkan notifikasi di foreground
  static Future<void> showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Channel untuk notifikasi utama',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: platformDetails,
      payload: data.isNotEmpty ? data.toString() : '',
    );
  }
}
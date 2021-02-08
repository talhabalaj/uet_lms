import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    plugin.initialize(initializationSettings,
        onSelectNotification: (v) async {});
  }

  Future<void> showNotification(
      {@required String title, @required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'general',
      'General',
      'All notifications of UET LMS',
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
      enableLights: true,
      playSound: true,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        
    await plugin.show(
      Random().nextInt(100),
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

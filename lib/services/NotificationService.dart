import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<int> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  // Request Exact Alarm Permission for Android 12 and above
  static Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid && (await getAndroidSdkVersion() >= 31)) {
      final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      bool? hasPermission = await androidPlugin?.requestExactAlarmsPermission();
      if (hasPermission!) {
        await androidPlugin?.requestExactAlarmsPermission();
      }
    }
  }

  // Request Notification Permission for Android 13+ and iOS
  static Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid && (await getAndroidSdkVersion() >= 33)) {
      final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Create Notification Channel for Android
  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'app name',
      'app channel',
      description: 'Notification channel for my app',
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void initialize() async {
    await requestExactAlarmPermission(); // Request permission for exact alarms on Android 12+
    await requestNotificationPermission(); // Request notification permission on Android 13+ and iOS
    await createNotificationChannel(); // Create notification channel for Android

    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse? response) {
    if (response != null) {
      print("Notification tapped with payload: ${response.payload}");
      // Handle notification actions here (e.g., navigate to a screen)
    }
  }

  static void displayText({required String title, required String body}) {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "app name",
        "app channel",
        channelDescription: "notification for my app",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  static Future<String> loadAsset(String asset, String filename) async {
    final byteData = await rootBundle.load(asset);
    final tmp = await getTemporaryDirectory();
    final file = File("${tmp.path}/$filename");
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file.path;
  }

  static Future<void> displayImage({
    required String title,
    required String body,
    required String icon,
    required String image,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var imageLoader = await loadAsset(image, 'bigpicture');
    var logoLoader = await loadAsset(icon, 'smallpicture');
    AndroidBitmap<Object> notificationImage = FilePathAndroidBitmap(imageLoader);
    AndroidBitmap<Object> notificationLogo = FilePathAndroidBitmap(logoLoader);

    final styleInfo = BigPictureStyleInformation(notificationImage, largeIcon: notificationLogo);

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "myapp",
        "my app channel",
        channelDescription: "Channel Description",
        priority: Priority.high,
        importance: Importance.high,
        styleInformation: styleInfo,
      ),
    );
    _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static void displayFcm({required RemoteNotification notification}) async {
    try {
      var styleInformationDesign;
      if (notification.android?.imageUrl != null) {
        final bigPicture = await _downloadAndSaveFile(notification.android!.imageUrl.toString(), 'bigPicture');
        final smallIcon = await _downloadAndSaveFile(notification.android!.imageUrl.toString(), 'smallIcon');
        styleInformationDesign = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicture),
          largeIcon: FilePathAndroidBitmap(smallIcon),
        );
      }

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "myapp",
          "myapp channel",
          channelDescription: "myapp channel description",
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: styleInformationDesign,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      await _flutterLocalNotificationsPlugin.show(id, notification.title, notification.body, notificationDetails);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static void scheduleNotification({
    required String title,
    required String body,
    required List<DateTime> scheduledTime,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'app name',
        'app channel',
        channelDescription: 'notification for my app',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    for (var dateTime in scheduledTime) {
      final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
      if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print("Skipping past date: $tzDateTime");
        continue; // Skip notifications scheduled in the past
      }

      final id = tzDateTime.millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'notification',
      );
    }
  }

  static void cancelNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

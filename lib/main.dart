// lib/main.dart

import 'dart:io';
import 'package:client/screens/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timezone/data/latest.dart' as tz;
import 'package:client/screens/auth/login_screen.dart';
import 'package:client/screens/sinistre/suivi_screen.dart';
import 'package:client/screens/sinistre/sinistre_form_screen.dart';
import 'package:client/screens/home_screen.dart';
import 'bottom_nav_bar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await _initializeNotifications();
  runApp(NotificationApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  tz.initializeTimeZones();
}

Future<void> _onSelectNotification(String? payload) async {
  if (payload != null) {
    print('notification payload: $payload');
    if (payload == 'SuiviScreen') {
      NotificationApp.navigatorKey.currentState?.pushNamed('/suivi');
    } else if (payload == 'SinistreFormScreen') {
      NotificationApp.navigatorKey.currentState?.pushNamed('/sinistre_form');
    }
  }
}

class NotificationApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              return BottomNavBar(); // Use BottomNavBar here
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/suivi': (context) => SuiviScreen(),
        '/sinistre_form': (context) => SinistreFormScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

import 'dart:io';
import 'package:client/ViewModel/auth_view_model.dart';
import 'package:client/ViewModel/sinistre_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/sinistre/suivi_screen.dart';
import 'screens/sinistre/sinistre_form_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile/ProfileScreen.dart';
import 'bottom_nav_bar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await _initializeNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => SinistreViewModel()),
      ],
      child: NotificationApp(),
    ),
  );
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
      home: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          if (authViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (authViewModel.isLoggedIn) {
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
}

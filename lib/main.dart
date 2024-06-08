import 'package:flutter/material.dart';
import 'package:client/screens/sinistre/suivi_screen.dart';
import 'package:client/screens/sinistre/sinistre_form_screen.dart';
import 'package:client/screens/sinistre/sinistre_detail_screen.dart'; // Import SinistreDetailScreen
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  runApp(NotificationApp());
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: _onSelectNotification,
  );
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
      home: SuiviScreen(), // Set SinistreFormScreen as the initial screen
      routes: {
        '/suivi': (context) => SuiviScreen(),
        '/sinistre_form': (context) => SinistreFormScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io('http://192.168.1.16:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('connected to server');
    });

    socket.on('notification', (data) {
      _showNotification(data['message']);
    });

    socket.on('disconnect', (_) {
      print('disconnected from server');
    });
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification',
      message,
      platformChannelSpecifics,
      payload: 'SuiviScreen', // Set payload for SuiviScreen
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification App'),
      ),
      body: Center(
        child: Text('Listening for notifications...'),
      ),
    );
  }
}

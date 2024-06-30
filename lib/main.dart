import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/MyHomePage.dart';
import 'package:client/SplashScreen.dart';
import 'package:client/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavProvider(),
      child: MaterialApp(
        title: 'Sinistre auto',
        theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}



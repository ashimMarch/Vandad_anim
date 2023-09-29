
import 'package:flutter/material.dart';

// import 'package:animation_tutorial/01_animatedbuilder/example1.dart';
// import '02_chained_animation/clippers.dart';
import '03_stack_rotate_3d/widget_rotaion3d.dart';
import '04_hero_animation/hero_animation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HeroAnim(),
    );
  }
}

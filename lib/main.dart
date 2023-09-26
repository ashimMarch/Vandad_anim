
import 'package:flutter/material.dart';
// import 'package:animation_tutorial/01_animatedbuilder/example1.dart';
import '02_chained_animation/clippers.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlippingHalfCircle(),
    );
  }
}

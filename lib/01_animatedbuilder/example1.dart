import 'dart:math' show pi;

import 'package:animation_tutorial/palette.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi
    ).animate(_controller);
    _controller.repeat();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Transform(
              alignment: Alignment.center,
              // origin: const Offset(25, -2),
              transform: Matrix4.identity()..rotateY(_animation.value),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0,3)
                    )
                  ]
                ),
              ),
            ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
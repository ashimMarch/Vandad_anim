import 'dart:math' show pi;

import 'package:animation_tutorial/palette.dart';
import 'package:flutter/material.dart';



extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}
class FlippingHalfCircle extends StatefulWidget {
  const FlippingHalfCircle({super.key});

  @override
  State<FlippingHalfCircle> createState() => _FlippingHalfCircleState();
}

class _FlippingHalfCircleState extends State<FlippingHalfCircle> with TickerProviderStateMixin{
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi/2.0),// -45 degree
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController, 
        curve: Curves.bounceOut
      ),
    );

    // flip animation

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut
      )
    );

    // --------------------------------- statusListener
    /// we need to know rotate animation is completed (_counterClockwiseRotationController)
    /// if it is completed we need to create new flip animation
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut
          )
        );

        // reset the flip controller. and start the animation
        _flipController..reset()..forward();
      }
    });

    // --------------------------------- statusListener
    /// we need to know flip animation is completed (_flipController)
    /// if it is completed we need to create new rotate animation
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value + -(pi/2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController, 
            curve: Curves.bounceOut,
          )
        );
      _counterClockwiseRotationController..reset()..forward();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 1),() {
    //   _counterClockwiseRotationController
    //   ..reset()
    //   ..forward();      
    // },);
    _counterClockwiseRotationController..reset()..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      backgroundColor: Palette.bgColor,
      appBar: AppBar(),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotationController,
          builder: (context, _) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_counterClockwiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                  animation: _flipController,
                    builder: (context, _) {
                      return Transform(
                        transform: Matrix4.identity()..rotateY(_flipAnimation.value),
                        alignment: Alignment.centerRight,
                        child: ClipPath(
                          clipper: const HalfCircleClipper(circleSide: CircleSide.left),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                  ),
                  AnimatedBuilder(
                    animation: _flipController,
                    builder: (context, _) {
                      return Transform(
                        transform: Matrix4.identity()..rotateY(_flipAnimation.value),
                        alignment: Alignment.centerLeft,
                        child: ClipPath(
                         clipper: const HalfCircleClipper(circleSide: CircleSide.right), 
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;

    late bool clockWise;
    switch (this){
      case CircleSide.left:
        /// start from topLeft 0 to topRight width of rectangle
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
      break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
      break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width/2, size.height/2),
      clockwise: clockWise,
    );

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path>{
  final CircleSide circleSide;

  const HalfCircleClipper({required this.circleSide});
  @override
  Path getClip(Size size) => circleSide.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}
import 'dart:math' show pi, sin, cos;

import 'package:flutter/material.dart';

class PolygonCusotmPainer extends StatefulWidget {
  const PolygonCusotmPainer({super.key});

  @override
  State<PolygonCusotmPainer> createState() => _PolygonCusotmPainerState();
}

class _PolygonCusotmPainerState extends State<PolygonCusotmPainer> with TickerProviderStateMixin{
  /// for number of sides of polygon. starting from triangle
  late AnimationController _sideController;
  late Animation<int> _sideAnimation;

  /// for changing width and height of canvas.
  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  /// for rotating polygon.
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  
  @override
  void initState() {
    super.initState();
    _sideController  = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3)
    );
    _sideAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(_sideController);

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3)
    );
    _radiusAnimation = Tween(
      begin: 20.0,
      end: 400.0,
    ).chain(
      CurveTween(curve: Curves.bounceInOut)
    ).animate(_radiusController);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3)
    );
    _rotationAnimation = Tween(
      begin: 0.0,
      end: 2 *pi,// 360
    ).chain(
      CurveTween(curve: Curves.easeInOut)
    ).animate(_rotationController);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sideController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }
  @override
  void dispose() {
    _sideController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _sideController,
            _radiusController,
            _rotationController,
          ]),
          builder: (context, _) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                    ..rotateX(_rotationAnimation.value)
                    ..rotateY(_rotationAnimation.value)
                    ..rotateZ(_rotationAnimation.value),
              child: CustomPaint(
                painter: Polygon(sides: _sideAnimation.value),
                child: SizedBox(
                  width: _radiusAnimation.value,
                  height: _radiusAnimation.value,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}


class Polygon extends CustomPainter{
  const Polygon({required this.sides});
  final int sides;

  @override
  void paint(Canvas canvas, Size size) {
    // Path() paint is like brush or paint
    final paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width/2, size.height/2);
    final angle = 2 * pi / sides;
    final angles = List.generate(sides, (index) => index * angle);
    /// sides = 5
    /// angle = 360/5 = 72    (2*pi / 5)
    /// angles = [ 72, 144, 216, 288, 360]
    
    final radius = size.width / 2;
    /*
      the brush isn't touch the screen. we nned to point that on circle circumference.
      on the circumferenc of the circle to get x

      center.x + radius * cos(angle)
      center.y + radius * sin(angle)
    */

    path.moveTo(
      center.dx + radius * cos(0), 
      center.dy + radius * sin(0)
    );

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle)
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => // old sides not equel to new side then it has to re draw
        oldDelegate is Polygon && oldDelegate.sides != sides;
  
}
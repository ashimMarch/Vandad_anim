
import 'dart:math' as math;
import 'package:flutter/material.dart';


Color getRandomColor() => Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));

class TweenAnimationBuilderWithClip extends StatefulWidget {
  const TweenAnimationBuilderWithClip({super.key});

  @override
  State<TweenAnimationBuilderWithClip> createState() => _TweenAnimationBuilderWithClipState();
}

class _TweenAnimationBuilderWithClipState extends State<TweenAnimationBuilderWithClip> {
  var _color = getRandomColor();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CircleClipper(),
          child: TweenAnimationBuilder(
            tween: ColorTween(
              begin: getRandomColor(),
              end: _color,
            ),
            onEnd: () {
              setState(() {
                _color = getRandomColor();
              });
            },
            duration: const Duration(seconds: 2),
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.red,
            ),
            builder: (context, color, child) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  color!, 
                  BlendMode.srcATop
                ),
                child: child!,
              );
            }
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path>{
  const CircleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width/2, size.height/2), 
      radius: size.width/2
    );

    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}
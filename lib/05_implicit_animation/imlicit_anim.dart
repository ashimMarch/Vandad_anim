


import 'package:flutter/material.dart';

class ImplicitAnimation extends StatefulWidget {
  const ImplicitAnimation({super.key});

  @override
  State<ImplicitAnimation> createState() => _ImplicitAnimationState();
}

  const defaultWidth = 100.0;
class _ImplicitAnimationState extends State<ImplicitAnimation> {

  var _isZoomedIn = false;
  var _buttonTitle = 'Zoome In';
  var _with = defaultWidth;
  var _curve = Curves.bounceOut;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 370),
                curve: _curve,
                width: _with,
                child: Image.asset(
                  'assets/images/insta.png'
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
             setState(() {
                _isZoomedIn = !_isZoomedIn;
                _buttonTitle = _isZoomedIn ? 'Zoom out' : 'Zoom In';
                _with = _isZoomedIn ? MediaQuery.of(context).size.width : defaultWidth;
                _curve = _isZoomedIn ? Curves.bounceInOut : Curves.bounceOut;
             });
            }, 
            child: Text(_buttonTitle)
          )
        ],
      ),
    );
  }
}
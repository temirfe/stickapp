import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class CustomOne extends StatefulWidget {
  const CustomOne({super.key});

  @override
  State<CustomOne> createState() => _CustomOneState();
}

class _CustomOneState extends State<CustomOne> {
  double _initialScale = 0.5;
  double _scale = 0.5;
  double _initialRotate = 0;
  double _rotate = 0;
  double finalScale = 1.0;
  double finalRotation = 0.0;
  ScaleUpdateDetails? scaleUpdate;
  ScaleStartDetails? scaleStart;
  final String _background =
      'https://images.unsplash.com/photo-1545147986-a9d6f2ab03b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleEnd: (details) {
          print('scale end $details');
        },
        onScaleStart: (details) {
          print('scale start $details');
          // you will need this in order to calculate difference
          // in rotation and scale:
          scaleStart = details;
          _initialScale = _scale;
          _initialRotate = _rotate;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          //print('scale update $details');
          setState(() {
            //finalScale = (scaleStart. - details.scale);
            //finalRotation = details.rotation;
            _scale = _initialScale * details.scale;
            _rotate = _initialRotate + details.rotation;
            print('rotation ${details.rotation}');
          });
        },
        child: Stack(children: [
          Image.network(_background),
          Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale))
              ..rotateZ(_rotate),
            child: Image.asset('assets/green_sticker.png'),
          )
        ]));
  }
}

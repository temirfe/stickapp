import 'package:flutter/material.dart';

class MyScale extends StatefulWidget {
  const MyScale({super.key});

  @override
  State<MyScale> createState() => _MyScaleState();
}

class _MyScaleState extends State<MyScale> {
  Color bgColor = Colors.yellow;
  bool makeCircular = false;
  double _scaleFactor = 0.5;
  double _baseScaleFactor = 0.5;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScaleFactor = _scaleFactor;
      },
      onScaleUpdate: (details) {
        print('scale ${details.scale}');
        setState(() {
          _scaleFactor = _baseScaleFactor * details.scale;
        });
      },
      onScaleEnd: (details) {
        // return to initial scale
        //_scaleFactor = _baseScaleFactor;
      },
      child: Transform.scale(
        scale: _scaleFactor,
        child: Card(
          shape: makeCircular
              ? const CircleBorder()
              : const RoundedRectangleBorder(),
          child: const SizedBox(
            height: 300,
            width: 300,
          ),
          color: bgColor,
        ),
      ),
    );
  }
}

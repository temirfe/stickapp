import 'package:flutter/material.dart';

// -------------------------------------------------------------------
// THE ITEM TO BE DRAWN
// -------------------------------------------------------------------

class DrawContainer {
  Color color;
  Offset offset;
  double width;
  double height;
  double scale;
  double angle;
  late double _baseScaleFactor;
  late double _baseAngleFactor;

  DrawContainer(this.color, this.offset, this.width, this.height, this.scale,
      this.angle) {
    onScaleStart();
  }

  onScaleStart() {
    _baseScaleFactor = scale;
    _baseAngleFactor = angle;
  }

  onScaleUpdate(double scaleNew) =>
      scale = (_baseScaleFactor * scaleNew).clamp(0.5, 5);

  onRotateUpdate(double angleNew) => angle = _baseAngleFactor + angleNew;
}

// -------------------------------------------------------------------
// APP
// -------------------------------------------------------------------

class GestureTest extends StatelessWidget {
  GestureTest({Key? key}) : super(key: key);

  final List<DrawContainer> containers = [
    DrawContainer(Colors.red, const Offset(50, 50), 100, 100, 1.0, 0.0),
    DrawContainer(Colors.yellow, const Offset(100, 100), 200, 100, 1.0, 0.0),
    DrawContainer(Colors.green, const Offset(150, 150), 50, 100, 1.0, 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            ...containers.map((e) {
              return _GDetector(e);
            }).toList(),
          ],
        ),
      ),
    ));
  }
}

class _GDetector extends StatefulWidget {
  const _GDetector(this.e, {super.key});
  final DrawContainer e;

  @override
  State<_GDetector> createState() => _GDetectorState();
}

class _GDetectorState extends State<_GDetector> {
  void onGestureStart(DrawContainer e) => e.onScaleStart();

  onGestureUpdate(DrawContainer e, ScaleUpdateDetails d) {
    e.offset = e.offset + d.focalPointDelta;
    if (d.rotation != 0.0) e.onRotateUpdate(d.rotation);
    if (d.scale != 1.0) e.onScaleUpdate(d.scale);
    setState(() {}); // redraw
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: (details) {
          // detect two fingers to reset internal factors
          if (details.pointerCount == 2) {
            onGestureStart(widget.e);
          }
        },
        onScaleUpdate: (details) => onGestureUpdate(widget.e, details),
        child: DrawWidget(widget.e));
  }
}

// -------------------------------------------------------------------
// POSITION, ROTATE AND SCALE THE WIDGET
// -------------------------------------------------------------------

class DrawWidget extends StatelessWidget {
  final DrawContainer e;
  const DrawWidget(this.e, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: e.offset.dx,
          top: e.offset.dy,
          child: Transform.rotate(
            angle: e.angle,
            child: Transform.scale(
              scale: e.scale,
              child: Container(
                height: e.width,
                width: e.height,
                color: e.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

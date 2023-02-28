import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as Vect;

class Custom3 extends StatefulWidget {
  final ValueChanged<double>? valueChanged;

  const Custom3({super.key, this.valueChanged});

  @override
  SliderState createState() {
    return SliderState();
  }
}

class SliderState extends State<Custom3> {
  ValueNotifier<double> valueListener = ValueNotifier(.0);

  @override
  void initState() {
    valueListener.addListener(notifyParent);
    super.initState();
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged!(valueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Builder(
        builder: (context) {
          final handle = GestureDetector(
            onHorizontalDragUpdate: (details) {
              valueListener.value =
                  (valueListener.value + details.delta.dx / context.size!.width)
                      .clamp(.0, 1.0);
            },
            child: const FlutterLogo(size: 50.0),
          );

          return AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(valueListener.value * 2 - 1, .5),
                child: child,
              );
            },
            child: handle,
          );
        },
      ),
    );
  }
}

class Custom4 extends StatefulWidget {
  const Custom4({super.key});

  @override
  State<Custom4> createState() => _Custom4State();
}

class _Custom4State extends State<Custom4> {
  final GlobalKey stackKey = GlobalKey();
  ValueNotifier<List<double>> posValueListener = ValueNotifier([0.0, 0.0]);
  ValueChanged<List<double>>? posValueChanged;
  double _horizontalPos = 0.0;
  double _verticalPos = 0.0;

  double _initialScale = 1;
  double _scale = 1;
  double _initialRotate = 0;
  double _rotate = 0;
  double finalScale = 1;
  double finalRotation = 0.0;

  @override
  void initState() {
    super.initState();

    posValueListener.addListener(() {
      if (posValueChanged != null) {
        posValueChanged!(posValueListener.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        key: stackKey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
      ),
      _buildDraggable(),
    ]));
  }

  _buildDraggable() {
    return SafeArea(
      child: Builder(
        builder: (context) {
          final keyContext = stackKey.currentContext;
          /* f (keyContext != null) {
            final box = keyContext.findRenderObject() as RenderBox;
            print('container height ${box.size.height}');
            print('container width ${box.size.width}');
          } else {
            print('no keyContext');
          } */
          final handle = GestureDetector(
            /* onPanUpdate: (details) {
                  _verticalPos = (_verticalPos +
                          details.delta.dy / (context.size!.height - 55))
                      .clamp(.0, 1.0);
                  _horizontalPos = (_horizontalPos +
                          details.delta.dx / (context.size!.width - 55))
                      .clamp(.0, 1.0);
                  posValueListener.value = [_horizontalPos, _verticalPos];
                  //print('horiz $_horizontalPos, vert $_verticalPos');
                }, */
            onScaleEnd: (details) {
              //print('onScaleEnd $details');
              // print('end rotate $_rotate');
              //print('end scale $_scale');
              finalRotation = _rotate;
              finalScale = _scale;
            },
            onScaleStart: (details) {
              //print('scale start $details');
              _initialScale = _scale;
              _initialRotate = _rotate;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              _verticalPos = (_verticalPos +
                      details.focalPointDelta.dy / (context.size!.height - 55))
                  .clamp(.0, 1.0);
              _horizontalPos = (_horizontalPos +
                      details.focalPointDelta.dx / (context.size!.width - 55))
                  .clamp(.0, 1.0);
              posValueListener.value = [_horizontalPos, _verticalPos];

              //print('scale update $details');
              setState(() {
                _scale = _initialScale * details.scale;
                _rotate = _initialRotate + details.rotation;
                // print('rotation ${details.rotation}');
              });
            },
            child: Transform(
                alignment: FractionalOffset.center,
                transform:
                    Matrix4.diagonal3(Vect.Vector3(_scale, _scale, _scale))
                      ..rotateZ(_rotate),
                child: Container(
                  //margin: EdgeInsets.all(12),
                  width: 110.0,
                  height: 110.0,
                  color: Colors.pink,
                )),
          );

          /* return ValueListenableBuilder<List<double>>(
              valueListenable: posValueListener,
              builder:
                  (BuildContext context, List<double> value, Widget? child) {
                return Align(
                  alignment: Alignment(value[0] * 2 - 1, value[1] * 2 - 1),
                  child: handle,
                );
              },
            ); */

          return AnimatedBuilder(
            animation: posValueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(posValueListener.value[0] * 2 - 1,
                    posValueListener.value[1] * 2 - 1),
                child: child,
              );
            },
            child: handle,
          );
        },
      ),
    );
  }
}

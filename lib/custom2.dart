import 'package:flutter/material.dart';

class DragBox extends StatefulWidget {
  const DragBox({super.key});
  final Offset initPos = const Offset(0.5, 0.5);

  @override
  State<DragBox> createState() => _DragBoxState();
}

class _DragBoxState extends State<DragBox> {
  var _x = 0.0;
  var _y = 0.0;
  final GlobalKey stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stackKey,
      fit: StackFit.expand,
      children: [
        Container(color: Colors.blue),
        Positioned(
          left: _x,
          top: _y,
          child: Draggable<Widget>(
            onDragUpdate: (dragDetails) {
              setState(() {
                final parentPos = stackKey.globalPaintBounds;
                if (parentPos == null) return;
              });
            },
            onDragEnd: (dragDetails) {
              setState(() {
                final parentPos = stackKey.globalPaintBounds;
                if (parentPos == null) return;
                var righBorder = (parentPos.right - 100);
                var x = dragDetails.offset.dx - parentPos.left;
                _y = dragDetails.offset.dy - parentPos.top;
                if (x > righBorder) {
                  x = righBorder;
                } else if (x < parentPos.left) {
                  x = parentPos.left;
                }
                _x = x;
              });
            },
            childWhenDragging: Container(),
            feedback: Container(width: 100, height: 100, color: Colors.orange),
            child: Container(width: 100, height: 100, color: Colors.pink),
          ),
        ),
      ],
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

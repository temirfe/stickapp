import 'package:flutter/material.dart';

class InteractiveViewerExample extends StatelessWidget {
  static const String imageUrl =
      'https://www.wallpapers13.com/wp-content/uploads/2016/01/Beautiful-lake-mountain-forest-desktop-wallpapers.jpg';

  static Matrix4 matrix4 =
      Matrix4(2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController controller = TransformationController(matrix4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Woolha.com Flutter Tutorial'),
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: controller,
          //          alignPanAxis: true,
          //          panEnabled: false,
          //          scaleEnabled: false,
          //          constrained: false,
          //          minScale: 0.5,
          //          maxScale: 10,
          child: Image.network(imageUrl),
          onInteractionStart: (ScaleStartDetails scaleStartDetails) {
            print(
                'Interaction Start - Focal point: ${scaleStartDetails.focalPoint}'
                ', Local focal point: ${scaleStartDetails.localFocalPoint}');
          },
          onInteractionEnd: (ScaleEndDetails scaleEndDetails) {
            print('Interaction End - Velocity: ${scaleEndDetails.velocity}');
          },
          onInteractionUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
            print(
                'Interaction Update - Focal point: ${scaleUpdateDetails.focalPoint}'
                ', Local focal point: ${scaleUpdateDetails.localFocalPoint}'
                ', Scale: ${scaleUpdateDetails.scale}'
                ', Horizontal scale: ${scaleUpdateDetails.horizontalScale}'
                ', Vertical scale: ${scaleUpdateDetails.verticalScale}'
                ', Rotation: ${scaleUpdateDetails.rotation}');
          },
        ),
      ),
    );
  }
}

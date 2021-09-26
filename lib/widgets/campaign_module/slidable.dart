import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class SliderWidget extends StatefulWidget {
  final double radius;
  const SliderWidget({
    Key? key,
    required this.radius,
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double radiuss = widget.radius;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: 500,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Radius'),
            Slider(
              value: radiuss,
              onChanged: (radius1) {
                setState(() {
                  radiuss = radius1;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  context
                      .read(mapProvider)
                      .RadiusAssign(radiuss.toDouble() * 100);
                  print(context.read(mapProvider).valueRadius);
                  Navigator.pop(context);
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sylviapp_project/screens/sidebar_module/drawer_screen.dart';
import 'package:sylviapp_project/screens/home.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration duration = Duration(milliseconds: 200);
  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            DrawerScreen(
              controller: _controller,
            ),
            HomePage(
              controller: _controller,
              duration: duration,
            ),
          ],
        ),
      ),
    );
  }
}

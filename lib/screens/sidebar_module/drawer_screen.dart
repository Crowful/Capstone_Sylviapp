import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/sidebar_module/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerScreen extends StatefulWidget {
  final AnimationController controller;

  const DrawerScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
  late Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller);

  @override
  Widget build(BuildContext context) {
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller);
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            SizedBox(height: 50),
            Row(children: [
              CircleAvatar(),
              SizedBox(width: 16),
              Expanded(
                  child: Text('test user',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)))
            ]),
            SizedBox(height: 30),
            MenuItem(
                route: "/settings", title: 'My Account', icon: Icons.person),
            MenuItem(
                route: "/settings",
                title: 'Recent Activity',
                icon: Icons.history),
            MenuItem(
                route: "/settings",
                title: 'Ongoing Campaign',
                icon: Icons.campaign),
            MenuItem(
              route: "/settings",
              title: 'Settings',
              icon: Icons.settings,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                context.read(authserviceProvider).signOut();
                Navigator.pushNamed(context, "/wrapperAuth");
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red[400],
                    size: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
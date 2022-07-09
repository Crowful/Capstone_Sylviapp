import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSnackBar {
  showCustomSnackBar(context, Color color, title, body) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Stack(clipBehavior: Clip.none, children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 85,
          width: MediaQuery.of(context).size.width - 2,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            margin: EdgeInsets.only(left: 50),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Spacer(),
              Text(
                body,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              )
            ]),
          ),
        ),
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            child: SvgPicture.asset(
              'assets/images/snackbarExit.svg',
              width: 100,
              height: 100,
            ),
          ),
        )
      ]),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }
}

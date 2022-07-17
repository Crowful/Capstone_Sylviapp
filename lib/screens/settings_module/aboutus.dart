import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _forestAnimationController;

  @override
  void initState() {
    super.initState();
    _forestAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _forestAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff65BFB8),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Color(0xff403d55),
                ),
                Text(
                  'Sylviapp',
                  style: TextStyle(
                      color: Color(0xff65BFB8),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_outline),
                  onPressed: () {},
                  color: Colors.transparent,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "About Us",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Text(
              'Sylviapp is a startup made by students in Technological Institute of the Philippines to solve the current problem of deforestation. ',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 20,
            ),
            LottieBuilder.asset(
              'assets/images/forest.json',
              controller: _forestAnimationController,
              onLoaded: (composition) {
                _forestAnimationController.duration = composition.duration;
                _forestAnimationController.forward();
              },
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'Joshua Peralta, Alfie Tribaco, and Rheanne Ongmanchi are the three students who came up with the idea of Sylviapp. Deforestation is still relevant today despite of huge community of volunteers that have no solid platform to settle their manpower and produce help to the environment. Sylviapp offers map as visual representation of deforestation in few forests which is actually operated by the officials in other end.',
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

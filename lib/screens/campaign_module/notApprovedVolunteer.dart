import 'package:flutter/material.dart';

class NotApprovedVolunteer extends StatefulWidget {
  const NotApprovedVolunteer({Key? key}) : super(key: key);

  @override
  _NotApprovedVolunteerState createState() => _NotApprovedVolunteerState();
}

class _NotApprovedVolunteerState extends State<NotApprovedVolunteer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          setState(() {
                            Navigator.pop(context);
                          });
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
                    ]),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thank you!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff65BFB8),
                            fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.check_circle_outline,
                        size: 70,
                        color: Color(0xff65BFB8),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Now you are a verified Sylviapp Volunteer!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff65BFB8),
                                fontSize: 17),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              'Please wait for the organizer to accept you as a volunteer. The organizer will review your credentials if you are qualified to join to this campaign. Thank you.'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Container(
                          width: 120,
                          height: 50,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff65BFB8),
                          ),
                          child: Center(child: Text('Back to Home')),
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.ac_unit,
                  color: Colors.transparent,
                )
              ]),
        ),
      ),
    );
  }
}

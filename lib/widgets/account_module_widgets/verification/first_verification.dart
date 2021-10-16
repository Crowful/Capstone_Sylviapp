import 'package:flutter/material.dart';

class FirstVerification extends StatefulWidget {
  final Widget nextButton;
  const FirstVerification({
    Key? key,
    required this.nextButton,
  }) : super(key: key);

  @override
  _FirstVerificationState createState() => _FirstVerificationState();
}

class _FirstVerificationState extends State<FirstVerification> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff65BFB8),
                  )),
              Text(
                'Account Verification',
                style: TextStyle(
                    color: Color(0xff65BFB8),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'You are a basic user!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Text(
                    'Get verified to become organizer and be able to lead and create a campaign!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Get Fully Verified in 5 minutes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.photo,
                            size: 35,
                            color: Color(0xff65BFB8),
                          ),
                          Text(
                            'Upload a Valid ID',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Valid IDs',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Colors.grey,
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 35,
                            color: Color(0xff65BFB8),
                          ),
                          Text(
                            'Take a Photo',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 35,
                            color: Color(0xff65BFB8),
                          ),
                          Text(
                            'Fill Information',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              widget.nextButton
            ],
          ),
        )
      ],
    );
  }
}

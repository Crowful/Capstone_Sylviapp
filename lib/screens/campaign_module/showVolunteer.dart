import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowVolunteer extends StatefulWidget {
  final String organizerID;
  final String userID;
  final String campaignID;
  const ShowVolunteer(
      {Key? key,
      required this.userID,
      required this.organizerID,
      required this.campaignID})
      : super(key: key);

  @override
  _ShowVolunteerState createState() => _ShowVolunteerState();
}

class _ShowVolunteerState extends State<ShowVolunteer> {
  late String? orgID = widget.organizerID;
  late String? userId = widget.userID;
  late String? campaignID = widget.campaignID;
  String? taske;
  String? errorText;
  String urlTest = "";
  Future showMedPic({orgID, campaignID, userID}) async {
    String fileName = "pic";

    String destination =
        '/files/users/$orgID/campaigns/$campaignID/volunteers/$userId/medical_picture/$fileName';
    // String destination =
    //     '//files/users/cf9HfG9DLXb8Gc3yzbKA7g1qpau1/campaigns/elgytiXREqLT2Cm/volunteers/orc9pQYQ01OLQZ1uDn11VEvAJLn1/medical_picture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    }
    if (this.mounted) {
      setState(() {
        urlTest = taske.toString();
      });
    }
  }

  String? taske1;
  String? errorText1;
  String urlTest1 = "";
  Future showVacPic({orgID, campaignID, userID}) async {
    String fileName = "pic";

    String destination =
        '/files/users/$orgID/campaigns/$campaignID/volunteers/$userId/vac_picture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske1 = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        errorText1 = e.toString();
        print('it aint workin`');
      });
    }
    if (this.mounted) {
      setState(() {
        urlTest1 = taske1.toString();
        print('it is workin`');
      });
    }
  }

  String? taske2;
  String? errorText2;
  String urlTest2 = "";
  Future showProfile(uid) async {
    String fileName = "pic";
    String destination = 'files/users/$uid/ProfilePicture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske2 = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        errorText2 = e.toString();
      });
    }
    if (this.mounted) {
      setState(() {
        urlTest2 = taske2.toString();
      });
    }
  }

  @override
  void initState() {
    //
    super.initState();

    showMedPic(
        orgID: widget.organizerID,
        campaignID: widget.campaignID,
        userID: widget.userID);
    showVacPic(
        orgID: widget.organizerID,
        campaignID: widget.campaignID,
        userID: widget.userID);
    showProfile(widget.userID);
    print(urlTest);
  }

  @override
  Widget build(BuildContext context) {
    print(urlTest);
    return Dialog(
      elevation: 3,
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              var name = AESCryptography().decryptAES(
                  enc.Encrypted.from64(snapshot.data!.get(("fullname"))));
              String? sentence = toBeginningOfSentenceCase(AESCryptography()
                  .decryptAES(
                      enc.Encrypted.from64(snapshot.data!.get(("gender")))));
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 405,
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Application Form",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xff65BFB8),
                              backgroundImage: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: urlTest2,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return CircularProgressIndicator();
                                },
                              ).image,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  sentence!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Medical Certificate',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                      return showFullImage(imgLink: urlTest);
                                    }));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(urlTest))),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Vaccination Card",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return showFullImage(
                                              imgLink: urlTest1);
                                        }));
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(urlTest1))),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 230,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey.withOpacity(0.3)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Checklists",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                      heightFactor: 8.5,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await context
                                    .read(authserviceProvider)
                                    .approveVolunteer(
                                        widget.campaignID, widget.userID);

                                context
                                    .read(authserviceProvider)
                                    .addJoinedLeaderboard(widget.userID, 1);
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Color(0xff65BFB8),
                                width: 160,
                                child: Center(child: Text("Approve")),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await context
                                      .read(authserviceProvider)
                                      .declineVolunteer(
                                          widget.campaignID, widget.userID);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Color(0xffFF683A),
                                  child: Center(child: Text("Decline")),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              );
            }
          }),
    );
  }

  Widget showFullImage({required String imgLink}) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 70, 10, 0),
          height: MediaQuery.of(context).size.height - 500,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imgLink)),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

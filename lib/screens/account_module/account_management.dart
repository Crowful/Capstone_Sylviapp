import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/wrapperAuth.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: Column(
            children: [
              Text("Delete Account"),
              ElevatedButton(
                  onPressed: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Are You sure about that?"),
                            content: Text("there's no turning back brother"),
                            actions: [
                              CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("no")),
                              CupertinoDialogAction(
                                  onPressed: () {
                                    context
                                        .read(authserviceProvider)
                                        .deleteAcc()
                                        .whenComplete(() => Navigator.pushNamed(
                                            context, "/wrapperAuth"));
                                  },
                                  child: Text("yes")),
                            ],
                          );
                        });
                  },
                  child: Text("Delete Account"))
            ],
          ),
        ),
      ),
    );
  }
}

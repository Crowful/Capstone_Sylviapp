import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/translations/locale_keys.g.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    String dropdownValue = "English";
    String newValues = "Tagalog";
    bool isSwitched = false;
    final isDark = watch(themingProvider);
    final isEnglish = watch(languageProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.sourceSansPro(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 35,
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.dark_mode,
                      size: 18,
                    )),
                    TextSpan(
                        text: '    Dark Mode', style: GoogleFonts.openSans())
                  ])),
                  Switch(
                      value: isDark.darkTheme,
                      onChanged: (value) {
                        context.read(themingProvider).toggleTheme();
                      },
                      activeTrackColor: Colors.green[400],
                      activeColor: Colors.white),
                ],
              ),
            ),
            Divider(),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.language,
                      size: 17,
                    )),
                    TextSpan(
                        text: '    Change Language',
                        style: GoogleFonts.openSans())
                  ])),
                  ElevatedButton(
                      onPressed: () async {
                        await context.setLocale(Locale('fil'));
                      },
                      child: Text(LocaleKeys.greetings.tr()))
                  // DropdownButton<String>(
                  //   value: dropdownValue,
                  //   icon: Icon(
                  //     Icons.arrow_downward,
                  //     color: isDark.darkTheme ? Colors.white : Colors.black,
                  //   ),
                  //   style: GoogleFonts.openSans(),
                  //   underline: Container(
                  //     height: 0,
                  //   ),
                  //   items: <String>['English', 'Tagalog']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem(
                  //       child: Text(
                  //         value,
                  //         style: GoogleFonts.openSans(
                  //             color: isDark.darkTheme
                  //                 ? Colors.white
                  //                 : Colors.black),
                  //       ),
                  //       value: value,
                  //     );
                  //   }).toList(),
                  //   onChanged: (newValues) async {
                  //     var tag = "Tagalog";
                  //     if (tag == "Tagalog") {
                  //       context.read(languageProvider).toggleLang();
                  //       await context.setLocale(Locale('fil'));
                  //     } else if (tag == "English") {
                  //       context.read(languageProvider).toggleLang();
                  //       await context.setLocale(Locale('en'));
                  //     }
                  //   },
                  // )
                ],
              ),
            ),
            Divider(),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.privacy_tip,
                      size: 17,
                    )),
                    TextSpan(text: '    Privacy', style: GoogleFonts.openSans())
                  ])),
                ],
              ),
            ),
            Divider(),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.help,
                      size: 17,
                    )),
                    TextSpan(text: '    Help', style: GoogleFonts.openSans())
                  ])),
                ],
              ),
            ),
            Divider(),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.info_rounded,
                      size: 17,
                    )),
                    TextSpan(
                        text: '    About us', style: GoogleFonts.openSans())
                  ])),
                ],
              ),
            ),
            Divider(),
            Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.feedback,
                      color: Colors.red,
                      size: 17,
                    )),
                    TextSpan(
                        text: '    Send Feedback',
                        style: GoogleFonts.openSans(
                          color: Colors.red,
                        ))
                  ])),
                ],
              ),
            ),
            Text(LocaleKeys.greetings.tr()),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/register");
                },
                child: Text('try registe'))
          ],
        ),
      ),
    );
  }
}

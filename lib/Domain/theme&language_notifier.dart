import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  bool _tagalogLang = false;
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }
 printAlfie(){
    print("Alfie C. Tribaco");
  }

  toggleLang() {
    _tagalogLang = !_tagalogLang;
    _saveToPrefs();
    notifyListeners();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;

    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref!.getBool(key) ?? true;
    _tagalogLang = _pref!.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref!.setBool(key, _tagalogLang);
    _pref!.setBool(key, _darkTheme);
  }
}

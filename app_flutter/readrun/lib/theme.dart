import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

ThemeData light = ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
         brightness: Brightness.light,

);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;
  bool _notification;
  String _picUrl;


  bool get darkTheme => _darkTheme;
  bool get notification => _notification;
  String get picUrl => _picUrl;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  NotificationNotifier() {
    _notification = true;
    _loadFromPrefs();
  }

  toggleTheme(bool value) {
    _darkTheme = !_darkTheme;
    _saveToPrefs('theme',value);
    notifyListeners();
  }
  toggleNotification(bool value) {
    _notification = !_notification;
    _saveToPrefs('notification',value);
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool('theme') ?? true;
    _notification = _prefs.getBool('notification') ?? true;
    _picUrl = _prefs.getString('picUrl');
    notifyListeners();
  }

  _saveToPrefs(String key,value)async {
    await _initPrefs();
    if(value==bool)
    {_prefs.setBool(key, value);}
    else{
      _prefs.setString(key, value);
    }
  }

}

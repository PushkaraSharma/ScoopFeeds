import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

ThemeData light = ThemeData(
         accentColor: kSecondaryColor,
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          toggleableActiveColor: kPrimaryColor ,
//          primaryColorLight: kPrimaryColor,
          textTheme: TextTheme(headline2:TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700, decoration: TextDecoration.none, fontFamily: 'CharterITC'),
           bodyText1: TextStyle(fontSize: 17.0, color: Colors.black54, decoration: TextDecoration.none, fontFamily: 'KievitOT', fontWeight: FontWeight.w300),
            bodyText2: TextStyle(color: Colors.black, decoration: TextDecoration.none, fontFamily: 'KievitOT'),
          ),
          sliderTheme: SliderThemeData(activeTrackColor: kPrimaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
         brightness: Brightness.light,

);

ThemeData dark = ThemeData(
  accentColor: kPrimaryColor,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: dBackgroundColor,
  primaryColor: dPrimaryColor,
  toggleableActiveColor: kSecondaryColor ,
//  primaryColorLight: kSecondaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(headline2:TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700, decoration: TextDecoration.none, fontFamily: 'CharterITC'),
    bodyText1: TextStyle(fontSize: 17.0, color: dTextColor, decoration: TextDecoration.none, fontFamily: 'KievitOT', fontWeight: FontWeight.w300),
    bodyText2: TextStyle(color: dTextColor, decoration: TextDecoration.none, fontFamily: 'KievitOT'),
  ),
  sliderTheme: SliderThemeData(activeTrackColor: kSecondaryColor),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;
  bool _notification;



  bool get darkTheme => _darkTheme;
  bool get notification => _notification;


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
    _darkTheme = _prefs.getBool('theme') ?? false;
    _notification = _prefs.getBool('notification') ?? true;
    notifyListeners();
  }

  _saveToPrefs(String key,bool value)async {
    await _initPrefs();
    _prefs.setBool(key, value);
  }

}

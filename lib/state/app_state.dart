import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/models/init.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends Model {
  AppState() {
    findTheme();
  }

  ThemeData _currentTheme;

  bool _loading = false;

  SharedPreferences prefs;

  findTheme() async {
    prefs = await SharedPreferences.getInstance();

    _currentTheme = ThemeData(
        platform: TargetPlatform.android,
        primaryColor: Colors.white,
        dividerColor: Color(0xFFEEEEEE),
        scaffoldBackgroundColor: Colours.bg_color,
        textTheme: TextTheme(body1: TextStyle(color: Colours.bg_gray)),
        fontFamily: 'PingFang');
  }

  ThemeData get theme => _currentTheme;

  set updateTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  bool get loading => _loading;

  updateLoading(bool load) {
    _loading = load;
    notifyListeners();
  }

  UserDaoService _dao = new UserDaoService();

  UserDaoService get dao => _dao;

  User _user = new User();

  User get user => _user;

  updateUser(User usr) {
    _user = usr;
    // notifyListeners();
  }
}

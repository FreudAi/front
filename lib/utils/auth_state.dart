import 'package:flutter/material.dart';

import '../model/user.dart';


class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;
  late User _user;
  String _redirectAfterLogin = "";

  User get user => _user;

  set user(user) => _user = user;

  bool get isAuthenticated => _isAuthenticated;
  set isAuthenticated(bool isAuth) => _isAuthenticated = isAuth;

  String get redirectAfterLogin => _redirectAfterLogin;
  set redirectAfterLogin(String path) => _redirectAfterLogin = path;

  void login(User user) {
    _user = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
  }
}
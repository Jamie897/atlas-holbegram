import 'package:flutter/material.dart';
import 'package:app/models/user.dart';
import 'package:app/methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Userd? _user;
  AuthMethods _authMethods = AuthMethods();

  Userd? get user => _user;

  Future<void> refreshUser() async {
    try {
      Userd userDetails = await _authMethods.getUserDetails();
      _user = userDetails;
      notifyListeners();
    } catch (e) {
      throw 'Failed to refresh user: $e';
    }
  }
}

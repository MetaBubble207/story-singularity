import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:storyhome/api/user.dart';
import 'package:storyhome/main.dart';

import '../models/user_info.dart';

// final Provider<UserInfo?> userProvider = Provider((_) => null);
final userProvider = StateNotifierProvider<User, UserInfo?>((ref) {
  return User(ref);
});

class User extends StateNotifier<UserInfo?> {
  User(this.ref) : super(null);

  final Ref ref;

  void load() {
    var u = prefs.getString('user');
    if (u == null) {
      state = null;
    } else {
      state = UserInfo.fromJson(jsonDecode(u));
    }
  }

  void login(String phoneNumber, String verifyCode) {
    UserApi.login(phoneNumber, verifyCode).then((newUserInfo) {
      prefs.setString('user', jsonEncode(newUserInfo?.toJson()));
      state = newUserInfo;
    });
  }

  void logout() {
    prefs.remove('user');
    state = null;
  }
}

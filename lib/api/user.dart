import 'dart:convert';

import 'package:storyhome/api/api.dart';
import 'package:storyhome/models/user_info.dart';

class UserApi {
  static Future<UserInfo?> login(String phone, String verifyCode) async {
    return UserInfo.fromJson((await Api.post('users/login', {
      'phone': phone,
      'verifyCode': verifyCode,
    }))['result']);
  }
}

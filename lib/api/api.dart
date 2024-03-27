import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../setting.dart';

class Api {
  static Map<String, dynamic> get headers {
    return {
      'Content-Type': 'application/json;charset=utf-8',
      // 'X-Token': mUserInfo?.token ?? '',
      // 'Platform': Platform.operatingSystem,
      // 'Time': getCurrentTime(),
    };
  }

  static Future<dynamic> post(String operation, dynamic postData) async {
    // if (!await check()) return null;
    try {
      var dio = Dio(BaseOptions(headers: headers));
      if (kDebugMode) {
        print('${Setting.serverHost}/$operation || $headers || $postData}');
      }
      var response = await dio.post(
        '${Setting.serverHost}/$operation',
        data: postData,
        options: Options(
          contentType:
              ContentType('application', 'json', charset: 'utf8').toString(),
        ),
      );
      var data = await response.data;
      print(data);
      if (data == null) {
        return null;
      }
      if (errorMessage(data)) return null;
      return data;
    } catch (e) {
      // showToast(e.toString());
    }
  }

  static int errorCounter = 0;

  static bool errorMessage(dynamic data) {
    if (kDebugMode) {
      print(data.toString());
    }
    try {
      // ErrorResp error = ErrorResp.fromJson(data);
      // if (error.status == 412) {
      //   showToast(error.message!);
      // }
      // if (error.status == 412 && errorCounter < 20) {
      //   if (errorCounter < 20) {
      //     refreshConnection();
      //     errorCounter++;
      //   } else {
      //     showToast('登录失效');
      //     prefs?.setString('userInfo', '');
      //     mUserInfo = null;
      //     return false;
      //   }
      //   return true;
      // }
      // if (error.status != 200 && error.status != 400) {
      //   showToast(error.message!);
      //   return true;
      // }
    } catch (e) {
//      showToast(e.toString());
//      return true;
    }
    return false;
  }
}

class ErrorResp {
  int? status;
  dynamic data;
  String? message;

  ErrorResp({this.status, this.data, this.message});

  ErrorResp.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    data = json?['data'];
    message = json?['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}

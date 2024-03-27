import 'package:dio/dio.dart';
import 'package:storyhome/api/api.dart';

import '../setting.dart';

class RecordApi {
  static Future<String> upload(String path, int userId) async {
    Dio dio = Dio();

    Map<String, dynamic> map = {};
    map["userId"] = userId;
    map["file"] = await MultipartFile.fromFile(path,
        filename: "record${DateTime.now().millisecondsSinceEpoch}.m4a");

    ///通过FormData
    FormData formData = FormData.fromMap(map);
    try {
      ///发送post
      Response response = await dio.post(
        '${Setting.serverHost}/recordings/saveRecordings', data: formData,

        ///这里是发送请求回调函数
        ///[progress] 当前的进度
        ///[total] 总进度
        onSendProgress: (int progress, int total) {
          print("当前进度是 $progress 总进度是 $total");
        },
      );

      // 服务器响应结果
      Map<dynamic, dynamic> data = response.data;
      print(data.toString());
      return data['result']?['text'] ?? '';
    } catch (e) {
      print(e);
    }
    return '';

    // Api.post(
    //   'recordings/saveRecordings',
    //   {
    //     'file': await MultipartFile.fromFile(path,
    //         filename: "record${DateTime.now().millisecondsSinceEpoch}.m4a"),
    //     'userId': userId
    //   },
    // ).then((value) => print(value));
  }
}

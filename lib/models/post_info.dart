import 'package:storyhome/models/user_info.dart';

class PostInfo {
  SimpleUserInfo? user;
  String? content;
  String? sound;
  int? soundSeconds;
  int? type;
  List<String>? images;

  PostInfo();

  PostInfo.fromJson(Map<String, dynamic>? json) {
    type = json?['type'];
    sound = json?['sound'];
    soundSeconds = json?['soundSeconds'];
    user = SimpleUserInfo.fromJson(json?['user']);
    content = json?['content'];
    if (json?['images'] != null) {
      images = [];
      json?['images'].forEach((v) {
        images!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['sound'] = sound;
    data['soundSeconds'] = soundSeconds;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['content'] = content;
    data['images'] = images;
    return data;
  }
}

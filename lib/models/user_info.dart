class UserInfoResp {
  int? status;
  UserInfo? data;
  String? message;

  UserInfoResp({this.status, this.data, this.message});

  UserInfoResp.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    data = json?['data'] != null ? UserInfo.fromJson(json?['data']) : null;
    message = json?['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class UserInfo {
  int? id;
  String? username;
  String? password;
  String? email;
  String? phone;
  String? createdAt;
  String? updateAt;

  UserInfo({this.id, this.username, this.password, this.email, this.phone});

  SimpleUserInfo toSimpleUserInfo() {
    return SimpleUserInfo()
      ..userId = id
      ..name = username;
  }

  UserInfo.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    username = json?['username'];
    password = json?['password'];
    email = json?['email'];
    phone = json?['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class SimpleUserInfoResp {
  int? status;
  SimpleUserInfo? data;
  String? message;

  SimpleUserInfoResp({this.status, this.data, this.message});

  SimpleUserInfoResp.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    data =
        json?['data'] != null ? SimpleUserInfo.fromJson(json?['data']) : null;
    message = json?['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SimpleUserInfo {
  int? userId;
  String? avatar;
  String? name;

  SimpleUserInfo({this.userId, this.avatar, this.name});

  SimpleUserInfo.fromJson(Map<String, dynamic>? json) {
    userId = json?['userId'];
    avatar = json?['avatar'];
    name = json?['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['avatar'] = avatar;
    data['name'] = name;
    return data;
  }
}

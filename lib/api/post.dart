import 'package:storyhome/api/api.dart';
import 'package:storyhome/models/post_info.dart';

class PostApi {
  static Future<PostInfo?> savePost(PostInfo post) async {
    return PostInfo.fromJson(
        (await Api.post('posts/savePost', post.toJson()))['result']);
  }

  static Future<List<PostInfo>> list(int pageNo, int pageNum, int key) async {
    List<Map<String, dynamic>> l = (await Api.post('posts/savePost', {
      'pageNo': pageNo,
      'pageNum': pageNum,
      'key': key,
    }))['result'];
    List<PostInfo> a =
        List.generate(l.length, (index) => PostInfo.fromJson(l[index]));
    return a;
  }
}

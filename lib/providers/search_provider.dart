import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:storyhome/models/post_info.dart';

var _data = [
  {
    'user': {'userId': 0, 'name': '张三'},
    'type': 0,
    'images': [],
    'content': '疏影横斜水清浅，暗香浮动月黄昏'
  },
  {
    'user': {'userId': 0, 'name': '李四'},
    'type': 0,
    'images': ['https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF'],
    'content': '疏影横斜水清浅，暗香浮动月黄昏'
  },
  {
    'user': {'userId': 0, 'name': '王五'},
    'type': 0,
    'sound': '.mp3',
    'soundSeconds': 12,
    'images': [],
    'content': ''
  }
];

List<PostInfo> _list =
    List.generate(_data.length, (index) => PostInfo.fromJson(_data[index]));

class PostNotifier extends PagedNotifier<int, PostInfo> {
  PostNotifier()
      : super(
          load: (page, limit) =>
              Future.delayed(const Duration(milliseconds: 500), () {
            // This simulates a network call to an api that returns paginated posts
            return List.generate(
                20, (index) => PostInfo.fromJson(_data[index % _data.length]));
            // return List.generate(
            //   20,
            //   (index) => PostInfo.fromJson({
            //     'user': {'userId': 0, 'name': '林冥箭'},
            //     'type': 0,
            //     'sound': '.mp3',
            //     'soundSeconds': 12,
            //     'images': [],
            //     'content': ''
            //   }),
            // );
          }),
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );

  // Super simple example of custom methods of the StateNotifier
  void add(PostInfo post) {
    state = state.copyWith(records: [...(state.records ?? []), post]);
  }

  void delete(PostInfo post) {
    state = state.copyWith(records: [...(state.records ?? [])]..remove(post));
  }
}

//create a global provider as you would normally in riverpod:
final postProvider =
    StateNotifierProvider<PostNotifier, PagedState<int, PostInfo>>(
        (_) => PostNotifier());

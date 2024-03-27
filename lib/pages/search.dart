import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:storyhome/components/post_container.dart';
import 'package:storyhome/models/post_info.dart';

import '../providers/search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool searching = true;
  final List<String> _tags = [
    '铃牙之旅',
    '三体',
    '斗罗大陆',
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CupertinoTheme(
      data: CupertinoThemeData(
        primaryColor: Theme.of(context).colorScheme.primary,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoTextField(
            autofocus: true,
            decoration: const BoxDecoration(color: Colors.transparent),
            controller: _searchController,
            placeholder: '震惊！TIM被MIT哈佛录取了！',
            suffix: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.search),
              onPressed: () {},
            ),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: searching
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 24),
                        child: Text(
                          '推荐搜索',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8.0,
                                children: _tags
                                    .map(
                                      (tag) => CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: colorScheme.background,
                                            ),
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                color: colorScheme.onBackground,
                                              ),
                                            )),
                                        onPressed: () {},
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : RiverPagedBuilder<int, PostInfo>(
                    firstPageKey: 0,
                    provider: postProvider,
                    itemBuilder: (context, item, index) => PostContainer(item),
                    pagedBuilder: (controller, builder) => PagedListView(
                        pagingController: controller, builderDelegate: builder),
                  ),
          ),
        ),
      ),
    );
  }
}

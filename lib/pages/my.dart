import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storyhome/fade_route.dart';
import 'package:storyhome/pages/login.dart';
import 'package:storyhome/pages/setting.dart';
import 'package:storyhome/pages/user.dart';
import 'package:storyhome/providers/user_provider.dart';

import '../components/cupertino_nav_bar.dart';
import '../components/ns_button.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => MyPageState();
}

class MyPageState extends ConsumerState<MyPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
    _scrollController.addListener(() {
      final nav = Navigator.of(context);
      final user = ref.watch(userProvider);

      if (_scrollController.offset < -10 && !nav.canPop() && user != null) {
        nav.push(
          FadeRoute(
            builder: (context) => const UserPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProvider);
    return CustomScrollView(
      controller: _scrollController,
      shrinkWrap: false,
      slivers: [
        CupertinoSliverNavigationBar2(
          largeTitle: const Text(''),
          backgroundColor: Colors.transparent, border: null,
          alwaysShowMiddle: false,
          // leading: Text(
          //   'Edit',
          //   style: TextStyle(color: CupertinoColors.link),
          // ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            child: Icon(
              Icons.settings,
              color: colorScheme.onBackground,
            ),
          ),
          // middle: const CircleAvatar(
          //   backgroundImage: AssetImage('images/avatar.webp'),
          // ),
          // middle: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: const [
          //     CupertinoActivityIndicator(),
          //     SizedBox(width: 8),
          //     Text('Waiting for network')
          //   ],
          // ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(top: 64.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            CupertinoTheme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user == null)
                            CupertinoButton.filled(
                                child: const Text('立即登陆'),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                })
                          else ...[
                            Text(user.username ?? '',
                                style: const TextStyle(fontSize: 24)),
                            const Text('粉丝：0 关注:0'),
                          ]
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -64),
                      child: const Hero(
                        tag: 'user_head',
                        child: CircleAvatar(
                          minRadius: 64,
                          maxRadius: 64,
                          backgroundImage: AssetImage('images/avatar.webp'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 设置水平滚动
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.thumb_up, '点赞', () {
                        // 点击点赞按钮后的处理逻辑
                      }),
                      _buildActionButton(Icons.queue_music, '听单', () {
                        // 点击听单按钮后的处理逻辑
                      }),
                      _buildActionButton(Icons.file_download, '下载', () {
                        // 点击下载按钮后的处理逻辑
                      }),
                      _buildActionButton(Icons.subscriptions, '订阅', () {
                        // 点击订阅按钮后的处理逻辑
                      }),
                      _buildActionButton(Icons.more_horiz, '更多服务', () {
                        // 点击更多服务按钮后的处理逻辑
                      }),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                // height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                var tabName = ['创作', '收藏', '历史'];
                                var a = (_pageController.positions.length == 1)
                                    ? 0
                                    : (index - (_pageController.page ?? 0))
                                        .abs()
                                        .toDouble();
                                var value = ((a < 1) ? (1 - a) * 0.2 : 0) + 0.8;
                                return AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: colorScheme.onBackground
                                          .withOpacity(value)),
                                  duration: const Duration(milliseconds: 100),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 64,
                                    child: NSButton(
                                      onPressed: () {
                                        _pageController.animateToPage(
                                          index,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOutCubic,
                                        );
                                      },
                                      child: Text(
                                        tabName[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: (_pageController.positions.isEmpty)
                                    ? 0
                                    : (_pageController.page ?? 0) * 64),
                            height: 2,
                            color: colorScheme.onBackground,
                            width: 64,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          const SizedBox(),
                          const SizedBox(),
                          const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        // ListView(
        //   physics: const BouncingScrollPhysics(),
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           CupertinoButton(
        //             onPressed: () {},
        //             child: const Icon(CupertinoIcons.settings),
        //           ),
        //         ],
        //       ),
        //     ),
        //  ],
        // ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 32.0),
          const SizedBox(height: 8.0),
          Text(label, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

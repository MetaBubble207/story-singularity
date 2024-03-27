import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storyhome/components/image_picture.dart';
import 'package:storyhome/pages/setting.dart';

import '../components/cupertino_nav_bar.dart';
import '../components/ns_button.dart';
import '../providers/user_provider.dart';
import 'login.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => UserPageState();
}

class UserPageState extends ConsumerState<UserPage> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProvider);
    return CupertinoPageScaffold(
      child: Stack(children: [
        const Positioned.fill(
          child: ImagePicture(fit: BoxFit.cover, url: 'images/2.jpg'),
        ),
        CustomScrollView(
          shrinkWrap: false,
          slivers: [
            const CupertinoSliverNavigationBar2(
              largeTitle: Text(''),
              backgroundColor: Colors.transparent, border: null,
              alwaysShowMiddle: false,
              // leading: Text(
              //   'Edit',
              //   style: TextStyle(color: CupertinoColors.link),
              // ),
              // trailing: CupertinoButton(
              //   padding: EdgeInsets.zero,
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       CupertinoPageRoute(
              //         builder: (context) => const SettingPage(),
              //       ),
              //     );
              //   },
              //   child: Icon(
              //     Icons.settings,
              //     color: colorScheme.onBackground,
              //   ),
              // ),
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
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 128),
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
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
                        Material(
                          type: MaterialType.transparency,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user?.username ?? '',
                                  style: const TextStyle(fontSize: 24)),
                              const Text('粉丝：0 关注:0'),
                            ],
                          ),
                        ),
                      ],
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
                                    var a = (_pageController.positions.length ==
                                            1)
                                        ? 0
                                        : (index - (_pageController.page ?? 0))
                                            .abs()
                                            .toDouble();
                                    var value =
                                        ((a < 1) ? (1 - a) * 0.2 : 0) + 0.8;
                                    return AnimatedDefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: colorScheme.onBackground
                                              .withOpacity(value)),
                                      duration:
                                          const Duration(milliseconds: 100),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 64,
                                        child: NSButton(
                                          onPressed: () {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                  milliseconds: 300),
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
        )
      ]),
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

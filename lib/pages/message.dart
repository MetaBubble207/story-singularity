import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:storyhome/components/ns_button.dart';

import 'chat.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(primaryColor: Colors.red),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('通知'),
          brightness: Theme.of(context).brightness,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future.delayed(const Duration(microseconds: 1000));
                  return Future.value(true);
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            child: Column(
                              children: [
                                const Icon(
                                  CupertinoIcons.heart_circle_fill,
                                  size: 32,
                                ),
                                const Text('赞和收藏')
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          child: CupertinoButton(
                            child: Column(
                              children: [
                                const Icon(
                                  CupertinoIcons.person_circle_fill,
                                  size: 32,
                                ),
                                const Text('新增关注')
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          child: CupertinoButton(
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.message_rounded,
                                  size: 32,
                                ),
                                Text('评论和@')
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const ChatPage(),
                              ),
                            );
                          },
                          child: Container(
                            // width: double.infinity,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(16),
                            //   color: CupertinoTheme.of(context)
                            //       .scaffoldBackgroundColor,
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black.withOpacity(0.2),
                            //       blurRadius: 24,
                            //       offset: const Offset(0, 8),
                            //     ),
                            //   ],
                            // ),
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 16, vertical: 8),
                            // margin: const EdgeInsets.symmetric(
                            //     horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      AssetImage('images/avatar.webp'),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            '张三',
                                          ),
                                          Text(
                                            '3月17日',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'Hello~',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

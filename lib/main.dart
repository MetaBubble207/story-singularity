import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:storyhome/pages/home.dart';
import 'package:storyhome/pages/message.dart';
import 'package:storyhome/pages/my.dart';
import 'package:storyhome/pages/player.dart';
import 'package:storyhome/pages/social.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyhome/providers/user_provider.dart';

import 'components/playing_ball.dart';
import 'pages/recording.dart';

int _pageIndex = 0;
var homeScreenSize = Size.zero;

// Obtain shared preferences.

late final SharedPreferences prefs;
void main() {
  runApp(const ProviderScope(
    child: StoryApp(),
  ));
}

class StoryApp extends StatelessWidget {
  const StoryApp({super.key});

  ThemeData getTheme(Brightness brightness) {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSeed(brightness: brightness, seedColor: Colors.red),
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '故事奇点',
      home: const Material(
        type: MaterialType.transparency,
        child: MyHomePage(title: '故事奇点'),
      ),
      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),
    );
    // return CupertinoApp(
    //   title: '故事奇点',
    //   useInheritedMediaQuery: true,
    //   home: const MyHomePage(title: '故事奇点'),
    //   theme: CupertinoThemeData(
    //     // brightness: Brightness.light,
    //     primaryColor: CupertinoColors.systemRed,
    //   ),
    // );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      ref.read(userProvider.notifier).load();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    homeScreenSize = MediaQuery.of(context).size;

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (value) {
          _pageIndex = value;
        },
        iconSize: 24,
        currentIndex: _pageIndex,
        items: [
          const BottomNavigationBarItem(
            label: '首页',
            icon: Icon(CupertinoIcons.house_fill),
          ),
          const BottomNavigationBarItem(
            label: '社区',
            icon: Icon(CupertinoIcons.person_2_fill),
          ),
          BottomNavigationBarItem(
            // label: '社区',
            icon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showBottomSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(),
                  color: colorScheme.primary,
                ),
                child: Icon(
                  CupertinoIcons.mic,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const BottomNavigationBarItem(
            label: '通知',
            icon: Icon(Icons.messenger_outline),
          ),
          const BottomNavigationBarItem(
            label: '我的',
            icon: Icon(CupertinoIcons.person_fill),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return [
          const HomePage(),
          const SocialPage(),
          const PlayerPage(),
          const MessagePage(),
          const MyPage()
        ][index];
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomSheetButton(CupertinoIcons.cloud_upload, '上传',
                      () {
// 点击上传按钮后的处理逻辑
                  }),
                  _buildBottomSheetButton(CupertinoIcons.mic, '录音', () {
// 点击录音按钮后的处理逻辑
                    var nav = Navigator.of(context);
                    nav.pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => const RecordingPage(),
                      ),
                    );
                  }),
                  _buildBottomSheetButton(CupertinoIcons.pencil, '说说', () {
// 点击说说按钮后的处理逻辑
                  }),
                ],
              ),
              const SizedBox(height: 16.0),
              CupertinoButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Align(
                  child: Icon(CupertinoIcons.chevron_compact_down, size: 32.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetButton(
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

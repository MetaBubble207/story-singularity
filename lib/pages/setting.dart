import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:storyhome/providers/user_provider.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    CSWidgetStyle brightnessStyle = const CSWidgetStyle(
        icon: Icon(CupertinoIcons.brightness, color: CupertinoColors.black));

    return CupertinoTheme(
      data: const CupertinoThemeData(primaryColor: CupertinoColors.systemRed),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: '我',
          middle: Text('设置'),
        ),
        child: SafeArea(
          bottom: false,
          child: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('我的信息'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('我的隐私管理'),
                    // value: Text('English'),
                  ),
                  SettingsTile.navigation(
                    // onToggle: (value) {},
                    // initialValue: true,
                    leading:
                        const Icon(CupertinoIcons.dot_radiowaves_left_right),
                    title: const Text('收听偏好设置'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('我的信息'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language),
                    title: const Text('安全设置'),
                    // value: Text('English'),
                  ),
                  SettingsTile.navigation(
                    onPressed: (context) {
                      showAboutDialog(
                          context: context, applicationName: '故事奇点');
                    },
                    // onToggle: (value) {},
                    // initialValue: true,
                    leading: const Icon(CupertinoIcons.info),
                    title: const Text('关于'),
                  ),
                ],
              ),
              SettingsSection(
                // title: Text('我的信息'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    onPressed: (context) {
                      ref.read(userProvider.notifier).logout();
                      Get.back();
                    },
                    // onToggle: (value) {},
                    // initialValue: true,
                    leading: const Icon(
                      CupertinoIcons.arrow_right_square,
                      color: Colors.red,
                    ),
                    title: const Text(
                      '退出登录',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
            // ),CupertinoSettings(
            //       items: <Widget>[
            //         const CSHeader('我的信息'),
            //         // CSWidget(
            //         //     CupertinoSlider(
            //         //       value: 0.5,
            //         //       onChanged: (double value) {},
            //         //     ),
            //         //     style: brightnessStyle),
            //         // CSControl(
            //         //   nameWidget: const Text('Auto brightness'),
            //         //   contentWidget: CupertinoSwitch(
            //         //     value: true,
            //         //     onChanged: (bool value) {},
            //         //   ),
            //         //   style: brightnessStyle,
            //         // ),
            //         // const CSHeader('Selection'),
            //         // CSSelection<int>(
            //         //   items: const <CSSelectionItem<int>>[
            //         //     CSSelectionItem<int>(text: 'Day mode', value: 0),
            //         //     CSSelectionItem<int>(text: 'Night mode', value: 1),
            //         //   ],
            //         //   onSelected: (index) {
            //         //     print(index);
            //         //   },
            //         //   currentSelection: 0,
            //         // ),
            //         // const CSDescription(
            //         //   'Using Night mode extends battery life on devices with OLED display',
            //         // ),
            //         // const CSHeader(''),
            //         CSLink(
            //           title: '我的隐私管理',
            //           onPressed: () {},
            //         ),
            //         CSLink(
            //           title: '收听偏好设置',
            //           onPressed: () {},
            //         ),
            //         const CSHeader('通用'),
            //         CSLink(
            //           title: '安全设置',
            //           onPressed: () {},
            //         ),
            //         CSLink(
            //           title: '关于',
            //           onPressed: () {
            //             showAboutDialog(context: context, applicationName: '故事奇点');
            //           },
            //         ),
            //         CupertinoTheme(
            //           child: CSLink(
            //             title: '退出登录',
            //             onPressed: () {},
            //           ),
            //         ),
            //         // CSControl(
            //         //   nameWidget: const Text('Loading...'),
            //         //   contentWidget: const CupertinoActivityIndicator(),
            //         // ),
            //         // CSButton(CSButtonType.DEFAULT, "Licenses", () {
            //         //   print("It works!");
            //         // }),
            //         // const CSHeader(''),
            //         // CSButton(CSButtonType.DESTRUCTIVE, "Delete all data", () {})
            //       ],
          ),
        ),
      ),
    );
  }
}

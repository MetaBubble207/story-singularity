import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginByPasswordPage extends StatefulWidget {
  const LoginByPasswordPage({super.key});

  @override
  LoginByPasswordPageState createState() => LoginByPasswordPageState();
}

class LoginByPasswordPageState extends State<LoginByPasswordPage> {
  String _phoneNumber = '';
  String _password = '';
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border.all(
          color: Colors.transparent,
        ),
        // middle: const Text('登录'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('帮助'),
          onPressed: () {
            // 点击帮助按钮的回调
          },
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  '密码登录',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                CupertinoTheme(
                  data: const CupertinoThemeData(),
                  child: CupertinoTextField(
                    prefix: const Text('  +86'),
                    placeholder: '请输入手机号',
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                  ),
                ),
                CupertinoTextField(
                  placeholder: '请输入密码',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? CupertinoColors.systemGreen
                                : CupertinoColors.white,
                            border: Border.all(
                              color: CupertinoColors.systemGrey,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.check_mark,
                            size: 16,
                            color: isChecked
                                ? CupertinoColors.white
                                : Colors.transparent,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: '同意',
                              style: TextStyle(color: colorScheme.onBackground),
                              children: [
                                TextSpan(
                                  text: '《用户服务协议》',
                                  style: TextStyle(color: colorScheme.primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      const url =
                                          'https://example.com/user-agreement';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: '和',
                                  style: TextStyle(
                                      color: colorScheme.onBackground),
                                ),
                                TextSpan(
                                  text: '《隐私政策》',
                                  style: TextStyle(color: colorScheme.primary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      const url =
                                          'https://example.com/privacy-policy';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    }),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: isChecked
                      ? () {
                          final bool isPhoneNumberValid =
                              _validatePhoneNumber(_phoneNumber);
                          if (!isPhoneNumberValid) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                content: const Text(
                                  '请输入正确的手机号',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('确认'),
                                    onPressed: () {
                                      Navigator.of(context).maybePop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          // 点击获取验证码的回调
                        }
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isChecked
                          ? colorScheme.primary
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Text(
                      '登陆',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePhoneNumber(String value) {
    // 验证手机号是否合规中国手机号
    RegExp regExp = RegExp(r'^1\d{10}$');
    return regExp.hasMatch(value);
  }
}

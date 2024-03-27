import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:storyhome/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_info.dart';

class LoginEnterCodePage extends ConsumerStatefulWidget {
  const LoginEnterCodePage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  LoginEnterCodePageState createState() => LoginEnterCodePageState();
}

class LoginEnterCodePageState extends ConsumerState<LoginEnterCodePage> {
  String _code = '';
  bool _onEditing = false;
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                '请输入验证码',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              VerificationCode(
                autofocus: true,
                keyboardType: TextInputType.number,
                underlineColor: colorScheme
                    .secondary, // If this is null it will use primaryColor: Colors.red from Theme
                length: 4,
                clearAll: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(CupertinoIcons.refresh),
                ),
                onCompleted: (String value) {
                  setState(() {
                    _code = value;
                  });
                },
                onEditing: (bool value) {
                  setState(() {
                    _onEditing = value;
                  });
                  if (!_onEditing) FocusScope.of(context).unfocus();
                },
              ),

              // CupertinoTextField(
              //   placeholder: '请输入验证码',
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) {
              //     setState(() {
              //       _code = value;
              //     });
              //   },
              // ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: (_code.length == 4)
                    ? () {
                        var nav = Navigator.of(context);
                        if (nav.canPop()) nav.pop();
                        if (nav.canPop()) nav.pop();
                        if (nav.canPop()) nav.pop();

                        ref
                            .read(userProvider.notifier)
                            .login(widget.phoneNumber, _code);
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
                    color: (_code.length == 4)
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
    );
  }
}

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:storyhome/components/image_picture.dart';
import 'package:storyhome/components/ns_button.dart';
import 'package:storyhome/pages/player.dart';

import '../main.dart';

PlayingBall? currentBall;

class PlayingBall extends StatefulWidget {
  final OverlayEntry? overlayEntry;

  const PlayingBall(
    this.overlayEntry, {
    Key? key,
  }) : super(key: key);

  static void add(BuildContext context) {
    if (currentBall != null) {
      return;
    }
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) {
        return (currentBall = PlayingBall(overlayEntry));
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  PlayingBallState createState() => PlayingBallState();
}

class PlayingBallState extends State<PlayingBall>
    with TickerProviderStateMixin {
  double? w, h;

  Offset twIdleOffset = const Offset(0, 0);
  Offset twMoveOffset = const Offset(0, 0);
  Offset twLastStartOffset = const Offset(0, 0);
  bool moving = false;

  String timeText = '0:00:00';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    w = 64;
    h = 64;
    twIdleOffset = Offset(0, Random().nextDouble() * homeScreenSize.height / 2);
    twMoveOffset = twIdleOffset;
    _animationController = AnimationController(vsync: this)
      ..drive(Tween(begin: 0, end: 1))
      ..duration = const Duration(milliseconds: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (moving)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade600.withOpacity(0),
                    Colors.red.shade600
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: homeScreenSize.height / 4,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                '拖动到底部关闭悬浮窗',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        Transform.translate(
          offset: twMoveOffset,
          child: GestureDetector(
            onPanStart: (detail) {
              setState(() {
                twLastStartOffset = detail.globalPosition;
                moving = true;
              });
            },
            onPanUpdate: (detail) {
              setState(() {
                twMoveOffset =
                    detail.globalPosition - twLastStartOffset + twIdleOffset;
                twMoveOffset = Offset(
                    max(MediaQuery.of(context).padding.left, twMoveOffset.dx),
                    max(MediaQuery.of(context).padding.top, twMoveOffset.dy));
                twMoveOffset = Offset(
                    min(twMoveOffset.dx,
                        MediaQuery.of(context).size.width - w!),
                    min(twMoveOffset.dy,
                        MediaQuery.of(context).size.height - h!));
              });
            },
            onPanEnd: (detail) {
              setState(() {
                twIdleOffset = twMoveOffset * 1;
                moving = false;
                if (G()) {
                  player.stop();
                  widget.overlayEntry!.remove();
                  currentBall = null;
                }
              });
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Positioned(
                //   right: -32,
                //   top: -32,
                //   child: NSButton(
                //     padding: const EdgeInsets.all(32),
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         color: Colors.black,
                //         shape: BoxShape.circle,
                //       ),
                //       padding: const EdgeInsets.all(4),
                //       child: const Icon(
                //         Icons.close,
                //         size: 16,
                //         color: Colors.white,
                //       ),
                //     ),
                //     onPressed: () {
                //       _timer?.cancel();
                //       widget.overlayEntry!.remove();
                //     },
                //   ),
                // ),
                AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCirc,
                  scale: (Navigator.of(context).canPop()) ? 0 : (G() ? 2 : 1),
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Positioned.fill(
                      child: NSButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const PlayerPage(),
                            ),
                          );
                          // if (_animationController.status ==
                          //     AnimationStatus.completed) {
                          //   player.play();
                          //   _animationController.reverse();
                          // } else if (_animationController.status ==
                          //     AnimationStatus.dismissed) {
                          //   player.pause();
                          //   _animationController.forward();
                          // }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                )
                              ]),
                          child: ClipOval(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: G() ? 0.5 : 1,
                                  child: const ImagePicture(
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      url:
                                          'https://imagev2.xmcdn.com/group36/M04/49/B2/wKgJUlooJ_jjahbeAAE-UMVQ8LQ835.png!strip=1&quality=7&magick=jpg&op_type=5&upload_type=album&name=mobile_large&device_type=ios'),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black38,
                                  ),
                                ),
                                // Positioned.fill(
                                //   child: NSButton(
                                //     onPressed: () {
                                //       Navigator.of(context).push(
                                //         CupertinoPageRoute(
                                //           builder: (context) => const PlayerPage(),
                                //         ),
                                //       );
                                //       // if (_animationController.status ==
                                //       //     AnimationStatus.completed) {
                                //       //   player.play();
                                //       //   _animationController.reverse();
                                //       // } else if (_animationController.status ==
                                //       //     AnimationStatus.dismissed) {
                                //       //   player.pause();
                                //       //   _animationController.forward();
                                //       // }
                                //     },
                                //     child: Icon(Icons.circle_outlined),
                                // child: StreamBuilder<ProcessingState>(
                                //   stream: player.processingStateStream,
                                //   builder: (context, snapshot) {
                                //     var processingState = snapshot.data;
                                //     return (processingState ==
                                //                 ProcessingState.loading ||
                                //             processingState ==
                                //                 ProcessingState.buffering)
                                //         ? const CupertinoActivityIndicator(
                                //             color: Colors.white,
                                //           )
                                //         : StreamBuilder<PlayerState>(
                                //             stream: player.playerStateStream,
                                //             builder: (context, snapshot) {
                                //               var state =
                                //                   snapshot.data?.playing ??
                                //                       false;
                                //               if (state) {
                                //                 _animationController.reverse();
                                //               } else {
                                //                 _animationController.forward();
                                //               }
                                //               return AnimatedIcon(
                                //                 icon: AnimatedIcons.pause_play,
                                //                 color: Colors.white,
                                //                 progress: _animationController,
                                //               );
                                //             },
                                //           );
                                //   },
                                // ),
                                // ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bool G() {
    return (twMoveOffset.dy > homeScreenSize.height / 4 * 3);
  }
}

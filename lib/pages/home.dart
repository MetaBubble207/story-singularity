import 'dart:ui';

import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'dart:math' as math;

import 'package:storyhome/components/ns_button.dart';
import 'package:storyhome/fade_route.dart';
import 'package:storyhome/pages/player.dart';

import '../components/image_picture.dart';
import '../components/playing_ball.dart';
import 'search.dart';

List<String> kDemoImages = [
  'https://i.pinimg.com/originals/7f/91/a1/7f91a18bcfbc35570c82063da8575be8.jpg',
  'https://www.absolutearts.com/portfolio3/a/afifaridasiddique/Still_Life-1545967888l.jpg',
  'https://cdn11.bigcommerce.com/s-x49po/images/stencil/1280x1280/products/53415/72138/1597120261997_IMG_20200811_095922__49127.1597493165.jpg?c=2',
  'https://i.pinimg.com/originals/47/7e/15/477e155db1f8f981c4abb6b2f0092836.jpg',
  'https://images.saatchiart.com/saatchi/770124/art/3760260/2830144-QFPTZRUH-7.jpg',
  'https://images.unsplash.com/photo-1471943311424-646960669fbc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8c3RpbGwlMjBsaWZlfGVufDB8fDB8&ixlib=rb-1.2.1&w=1000&q=80',
  'https://cdn11.bigcommerce.com/s-x49po/images/stencil/1280x1280/products/40895/55777/1526876829723_P211_24X36__2018_Stilllife_15000_20090__91926.1563511650.jpg?c=2',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIUsxpakPiqVF4W_rOlq6eoLYboOFoxw45qw&usqp=CAU',
  'https://images.mojarto.com/photos/267893/large/DA-SL-01.jpg?1560834975',
];

InfiniteScrollController _controller = InfiniteScrollController();
PageController _pageController = PageController(initialPage: 1);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabName = ['关注', '推荐', '排行榜', '精选'];
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double itemExtent = MediaQuery.of(context).size.width * 0.7;
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                  child: NSButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        FadeRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0x3d767680),
                          borderRadius: BorderRadius.circular(9.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Icon(
                              CupertinoIcons.search,
                              size: 20,
                            ),
                          ),
                          Text(
                            '搜索',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                offset: const Offset(0, 48),
                icon: Icon(
                  CupertinoIcons.add_circled,
                  color: colorScheme.primary,
                ),
                itemBuilder: (BuildContext context) => const <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'scan',
                    child: ListTile(
                      leading: Icon(Icons.qr_code),
                      title: Text('扫一扫'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('设置'),
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'scan':
                      // 执行扫一扫操作
                      break;
                    case 'settings':
                      // 执行设置操作
                      break;
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabName.length,
                      itemBuilder: (context, index) {
                        var a = (index - (_pageController.page ?? 0))
                            .abs()
                            .toDouble();
                        var value = ((a < 1) ? (1 - a) * 0.2 : 0) + 0.8;
                        return AnimatedDefaultTextStyle(
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  colorScheme.onBackground.withOpacity(value)),
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            alignment: Alignment.center,
                            width: 64,
                            child: NSButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
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
                    color: colorScheme.onBackground,
                    margin: EdgeInsets.only(
                        left: (_pageController.positions.isEmpty)
                            ? 1
                            : (_pageController.page ?? 1) * 64),
                    height: 2,
                    width: 64,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {});
              },
              children: [
                buildFragment(colorScheme, itemExtent),
                buildRecommendFragment(colorScheme, itemExtent),
                buildFragment(colorScheme, itemExtent),
                buildFragment(colorScheme, itemExtent),
              ],
            ),
          ),
          // Expanded(
          //   child: PageView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //
          //       CustomScrollView(
          //         shrinkWrap: false,
          //         slivers: [
          //           CupertinoSliverRefreshControl(
          //             onRefresh: () async {
          //               await Future.delayed(
          //                   const Duration(microseconds: 1000));
          //               return Future.value(true);
          //             },
          //           ),
          //           SliverList(
          //               delegate: SliverChildListDelegate([
          //             SizedBox(
          //               height: 240,
          //               child: InfiniteCarousel.builder(
          //                 itemCount: 3,
          //                 itemExtent: itemExtent,
          //                 center: _center,
          //                 anchor: _anchor,
          //                 velocityFactor: _velocityFactor,
          //                 scrollBehavior: kIsWeb
          //                     ? ScrollConfiguration.of(context).copyWith(
          //                         dragDevices: {
          //                           // Allows to swipe in web browsers
          //                           PointerDeviceKind.touch,
          //                           PointerDeviceKind.mouse
          //                         },
          //                       )
          //                     : null,
          //                 controller: _controller,
          //                 itemBuilder: (context, itemIndex, realIndex) {
          //                   final currentOffset = itemExtent * realIndex;
          //                   return AnimatedBuilder(
          //                     animation: _controller,
          //                     builder: (context, child) {
          //                       final diff =
          //                           (_controller.offset - currentOffset);
          //                       final maxPadding = 10.0;
          //                       final carouselRatio = itemExtent / maxPadding;

          //                       return Padding(
          //                         padding: EdgeInsets.only(
          //                           top: (diff / carouselRatio).abs(),
          //                           bottom: (diff / carouselRatio).abs(),
          //                         ),
          //                         child: child,
          //                       );
          //                     },
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(2.0),
          //                       child: Container(
          //                         height: 128,
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(5),
          //                           boxShadow: kElevationToShadow[2],
          //                           color: Colors.red,
          //                         ),
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               ),
          //             ),
          //           ])),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ));
  }

  var carIndex = 0;

  buildFragment(ColorScheme colorScheme, double itemExtent) {
    return CustomScrollView(
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
                height: 8,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 64,
                itemBuilder: (context, index) {
                  return buildPlayCard(context, colorScheme, index);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  buildRecommendFragment(ColorScheme colorScheme, double itemExtent) {
    return CustomScrollView(
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
              SizedBox(
                height: MediaQuery.of(context).size.width / 4 * 3 * 0.7,
                child: InfiniteCarousel.builder(
                  onIndexChanged: (index) {
                    carIndex = index;
                    setState(() {});
                  },
                  itemCount: 4,
                  itemExtent: itemExtent,
                  // center: _center,
                  // anchor: _anchor,
                  // velocityFactor: 1,
                  // physics: const InfiniteScrollPhysics(),
                  // scrollBehavior: kIsWeb
                  //     ? ScrollConfiguration.of(context).copyWith(
                  //         dragDevices: {
                  //           // Allows to swipe in web browsers
                  //           PointerDeviceKind.touch,
                  //           PointerDeviceKind.mouse
                  //         },
                  //       )
                  //     : null,
                  controller: _controller,
                  itemBuilder: (context, itemIndex, realIndex) {
                    final currentOffset = itemExtent * realIndex;
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final diff = (_controller.offset - currentOffset);
                        const maxPadding = 10.0;
                        final carouselRatio = itemExtent / maxPadding;

                        return Padding(
                          padding: EdgeInsets.only(
                            top: (diff / carouselRatio).abs(),
                            bottom: (diff / carouselRatio).abs(),
                          ),
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 2),
                        child: Container(
                          height: 128,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(5),
                            boxShadow: kElevationToShadow[2],
                            // color: Colors.red,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ImagePicture(
                              fit: BoxFit.cover,
                              url: 'images/${itemIndex + 1}.jpg',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      height: 8,
                      width: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.onBackground
                            .withOpacity((i == carIndex) ? 1 : 0.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 64,
                itemBuilder: (context, index) {
                  return buildPlayCard(context, colorScheme, index);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPlayCard(
      BuildContext context, ColorScheme colorScheme, int index) {
    return NSButton(
      onPressed: () {
        PlayingBall.add(context);
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const PlayerPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 128,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      '我被MIT哈佛录取了！计算机博士申请季纪实',
                      '老高讲故事',
                      '社恐的我第一次有了喜欢的人',
                      '二舅治好了我的精神内耗',
                      '坚持喜欢一个女生16年是一种什么体验？',
                      '超甜！从校服同桌到婚纱老婆，真的太泪目了！',
                      '我是如何堕落的',
                      '千万不要靠近这类人！'
                    ][index % 7],
                  ),
                  const Text(
                    '15.6万次播放 总时长14：51',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.play_circle,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

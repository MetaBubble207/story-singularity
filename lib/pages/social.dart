import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import 'dart:math' as math;

import 'package:storyhome/components/ns_button.dart';

import '../components/image_picture.dart';
import '../components/post_container.dart';
import '../fade_route.dart';
import '../models/post_info.dart';
import '../providers/search_provider.dart';
import 'photo_gallery_page.dart';

PageController _pageController = PageController(initialPage: 1);

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => SocialPageState();
}

class SocialPageState extends State<SocialPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double itemExtent = MediaQuery.of(context).size.width * 0.7;
    var tabName = ['关注', '推荐', '本地'];
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
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
                        var a = (index - (_pageController.page ?? 1))
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
                _buildFollowingFragment(context, itemExtent, colorScheme),
                _buildRecommendFragment(context, itemExtent, colorScheme),
                _buildLocalFragment(context, itemExtent, colorScheme),
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
}

_buildLocalFragment(
    BuildContext context, double itemExtent, ColorScheme colorScheme) {
  Size size = MediaQuery.of(context).size;
  return CustomScrollView(
    slivers: [
      CupertinoSliverRefreshControl(
        onRefresh: () async {
          await Future.delayed(const Duration(microseconds: 1000));
          return Future.value(true);
        },
      ),
      RiverPagedBuilder<int, PostInfo>(
        firstPageKey: 0,
        provider: postProvider,
        itemBuilder: (context, item, index) => PostContainer(item),
        pagedBuilder: (controller, builder) => PagedSliverList(
            pagingController: controller, builderDelegate: builder),
      )
      // SliverList(
      //   delegate: SliverChildListDelegate(
      //     [
      //       RiverPagedBuilder<int, PostInfo>(
      //         firstPageKey: 0,
      //         provider: postProvider,
      //         itemBuilder: (context, item, index) => PostContainer(item),
      //         pagedBuilder: (controller, builder) => PagedListView(
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             pagingController: controller,
      //             builderDelegate: builder),
      //       )
      //       // ListView.builder(
      //       //   physics: const NeverScrollableScrollPhysics(),
      //       //   shrinkWrap: true,
      //       //   itemCount: _data.length,
      //       //   itemBuilder: (context, index) {
      //       //     final item = _list[index];
      //       //     return PostContainer(item);
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
    ],
  );
}

_buildRecommendFragment(
    BuildContext context, double itemExtent, ColorScheme colorScheme) {
  Size size = MediaQuery.of(context).size;
  return CustomScrollView(
    slivers: [
      CupertinoSliverRefreshControl(
        onRefresh: () async {
          await Future.delayed(const Duration(microseconds: 1000));
          return Future.value(true);
        },
      ),
      RiverPagedBuilder<int, PostInfo>(
        firstPageKey: 0,
        provider: postProvider,
        itemBuilder: (context, item, index) => PostContainer(item),
        pagedBuilder: (controller, builder) => PagedSliverList(
            pagingController: controller, builderDelegate: builder),
      )
      // SliverList(
      //   delegate: SliverChildListDelegate(
      //     [
      //       RiverPagedBuilder<int, PostInfo>(
      //         firstPageKey: 0,
      //         provider: postProvider,
      //         itemBuilder: (context, item, index) => PostContainer(item),
      //         pagedBuilder: (controller, builder) => PagedListView(
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             pagingController: controller,
      //             builderDelegate: builder),
      //       )
      //       // ListView.builder(
      //       //   physics: const NeverScrollableScrollPhysics(),
      //       //   shrinkWrap: true,
      //       //   itemCount: _data.length,
      //       //   itemBuilder: (context, index) {
      //       //     final item = _list[index];
      //       //     return PostContainer(item);
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
    ],
  );
}

_buildFollowingFragment(
    BuildContext context, double itemExtent, ColorScheme colorScheme) {
  Size size = MediaQuery.of(context).size;
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
              height: 48,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    child: Text('A'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      RiverPagedBuilder<int, PostInfo>(
        firstPageKey: 0,
        provider: postProvider,
        itemBuilder: (context, item, index) => PostContainer(item),
        pagedBuilder: (controller, builder) => PagedSliverList(
            pagingController: controller, builderDelegate: builder),
      )
    ],
  );
}

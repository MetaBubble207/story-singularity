import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:math' as math;
import '../fade_route.dart';
import '../models/post_info.dart';
import '../pages/photo_gallery_page.dart';
import 'image_picture.dart';
import 'ns_button.dart';

int _count = 0;

class PostContainer extends StatelessWidget {
  const PostContainer(this.item, {super.key});

  final PostInfo item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;
    _count++;
    final c = _count;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.primaryContainer,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
        //     blurRadius: 24,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('images/avatar.webp'),
                radius: 16,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                item.user?.name ?? '',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          if ((item.content ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                item.content ?? '',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
            ),
          if (item.sound != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.primary,
              ),
              margin: const EdgeInsets.only(
                top: 8,
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    CupertinoIcons.waveform,
                    color: colorScheme.onPrimary,
                  ),
                  Text(
                    '${item.soundSeconds ?? '? '}\'',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          if ((item.images ?? []).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(
                left: 40,
                top: 8,
              ),
              constraints: BoxConstraints(maxHeight: size.height / 3),
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                ),
                children: [
                  for (final image in item.images!)
                    NSButton(
                      child: Hero(
                        tag: '$image#$c',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImagePicture(
                            url: image,
                            fit: BoxFit.cover,
                            height: math.min(size.width, size.height / 3),
                            width: size.width,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          FadeRoute(
                            builder: (context) {
                              return PhotoViewGalleryScreen(
                                images: item.images!
                                    .map((e) => NetworkImage(e))
                                    .toList(), //传入图片list
                                index: 0, //传入当前点击的图片的index
                                heroTag:
                                    '$image#$c', //传入当前点击的图片的hero tag （可选）
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

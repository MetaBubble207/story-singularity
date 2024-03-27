import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:storyhome/components/cupertino_nav_bar.dart';
import 'package:storyhome/components/ns_button.dart';
import 'package:storyhome/pages/photo_gallery_page.dart';

import '../components/image_picture.dart';
import '../components/playing_ball.dart';
import '../fade_route.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  PlayerPageState createState() => PlayerPageState();
}

final AudioPlayer player = AudioPlayer();

Duration _duration = const Duration(hours: 100);
Duration _position = Duration.zero;

class PlayerPageState extends State<PlayerPage> {
  String _title = '科学星期五';
  String _album = 'Album Name';

  @override
  void initState() {
    super.initState();
    // _player.setUrl('https://example.com/song.mp3');
    // _player.durationStream
    //     .listen((d) => setState(() => _duration = d ?? Duration.zero));
    // _player.positionStream.listen((p) => setState(() => _position = p));
    if (player.playing) return;
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      player
          .setAudioSource(AudioSource.uri(Uri.parse(
              "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")))
          .then((value) {
        _duration = value ?? _duration;
        player.play();
        if (mounted) setState(() {});
      });
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  static const image =
      'https://imagev2.xmcdn.com/group36/M04/49/B2/wKgJUlooJ_jjahbeAAE-UMVQ8LQ835.png!strip=1&quality=7&magick=jpg&op_type=5&upload_type=album&name=mobile_large&device_type=ios';

  Duration get _remaining => _duration - _position;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CupertinoPageScaffold(
      child: Material(
        type: MaterialType.transparency,
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar2(
              // padding: EdgeInsetsDirectional.zero,
              // backgroundColor: Colors.transparent,
              border: Border.all(color: Colors.transparent),
              middle: Text(
                _title,
                style: TextStyle(
                  color: colorScheme.primary,
                ),
              ),
              // leading: CupertinoButton(
              //     padding: EdgeInsets.zero,
              //     onPressed: () {
              //       Navigator.of(context).maybePop();
              //     },
              //     child: const Icon(CupertinoIcons.chevron_down)),
              largeTitle: const Text(''),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<Duration>(
                  initialData: Duration.zero,
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    if (data != null) {
                      _position = data;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Center(
                          child: Hero(
                            tag: image,
                            child: NSButton(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const ImagePicture(
                                  url: image,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  FadeRoute(
                                    builder: (context) {
                                      return const PhotoViewGalleryScreen(
                                        images: [NetworkImage(image)],
                                        // images: item.images!
                                        //     .map((e) => NetworkImage(e))
                                        //     .toList(), //传入图片list
                                        index: 0, //传入当前点击的图片的index
                                        heroTag:
                                            image, //传入当前点击的图片的hero tag （可选）
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              child:
                                  const Icon(CupertinoIcons.arrow_down_circle),
                              onPressed: () {},
                            ),
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.fullscreen),
                              onPressed: () {},
                            ),
                            CupertinoButton(
                              child: const Icon(Icons.message_rounded),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CupertinoSlider(
                          value: _position.inSeconds.toDouble(),
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChangeStart: (value) => player.pause(),
                          onChangeEnd: (double value) => player.play(),
                          onChanged: (double value) =>
                              player.seek(Duration(seconds: value.toInt())),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                ' ${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                            Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                    .firstMatch("$_remaining")
                                    ?.group(1) ??
                                '$_remaining')
                            // Text(
                            //     '${_duration.inMinutes}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')} '),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.gobackward_15),
                              onPressed: () => player.seek(
                                  _position - const Duration(seconds: 15)),
                            ),
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.backward_end),
                              onPressed: () {},
                            ),
                            StreamBuilder<ProcessingState>(
                              stream: player.processingStateStream,
                              builder: (context, snapshot) {
                                var processingState = snapshot.data;
                                return CupertinoButton(
                                  child: (processingState ==
                                              ProcessingState.loading ||
                                          processingState ==
                                              ProcessingState.buffering)
                                      ? const CupertinoActivityIndicator()
                                      : Icon(player.playing
                                          ? CupertinoIcons.pause
                                          : CupertinoIcons.play_arrow),
                                  onPressed: () {
                                    player.playing
                                        ? player.pause()
                                        : player.play();
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.forward_end),
                              onPressed: () {},
                            ),
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.goforward_15),
                              onPressed: () => player.seek(
                                  _position + const Duration(seconds: 15)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: colorScheme.secondaryContainer
                              // color:
                              //     CupertinoTheme.of(context).scaffoldBackgroundColor,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2),
                              //     blurRadius: 24,
                              //     offset: const Offset(0, 8),
                              //   ),
                              // ],
                              ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '计算机大学',
                                      style: TextStyle(
                                        color: colorScheme.onSecondaryContainer,
                                      ),
                                    ),
                                    const Text(
                                      '15.6万人订阅',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              NSButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorScheme.tertiary),
                                  child: Text(
                                    '立即订阅',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onTertiary),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(8),
                          height: 128,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.secondaryContainer),
                          child: Column(
                            children: [
                              Text(
                                '收听本节目的人还听',
                                style: TextStyle(
                                    color: colorScheme.onSecondaryContainer),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

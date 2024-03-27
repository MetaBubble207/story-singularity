import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This is a minimal example demonstrating a play/pause button and a seek bar.
// More advanced examples demonstrating other features can be found in the same
// directory as this example in the GitHub repository.

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';

import 'package:rxdart/rxdart.dart';

import 'dart:math';

import 'package:storyhome/api/record.dart';
import 'package:storyhome/main.dart';
import 'package:storyhome/providers/user_provider.dart';

String text = '';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? value) => value;

class RecordedPage extends StatefulWidget {
  const RecordedPage({super.key, required this.path});

  final String path;

  @override
  RecordedPageState createState() => RecordedPageState();
}

class RecordedPageState extends State<RecordedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('录音完成'),
      ),
      body: PlayerModule(
        path: widget.path,
      ),
    );
  }
}

class PlayerModule extends ConsumerStatefulWidget {
  const PlayerModule({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  PlayerModuleState createState() => PlayerModuleState();
}

class PlayerModuleState extends ConsumerState<PlayerModule>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();
  bool uploading = false;
  final TextEditingController _editingController =
      TextEditingController(text: text);

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    text = '';
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors d`uri`ng playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      print(widget.path);
      await _player
          .setAudioSource(AudioSource.uri(Uri.parse('file:${widget.path}')));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the _player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: uploading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (text.isNotEmpty)
                  SizedBox(
                    height: homeScreenSize.height / 3,
                    width: homeScreenSize.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(),
                          child: CupertinoTextField(
                            controller: _editingController,
                            minLines: 10,
                            maxLines: 10000,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 32,
                            height: 32,
                            child: const CupertinoActivityIndicator(),
                          );
                        } else if (playing != true) {
                          return IconButton(
                            icon: const Icon(CupertinoIcons.play_arrow),
                            iconSize: 32,
                            onPressed: _player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: const Icon(CupertinoIcons.pause),
                            iconSize: 32,
                            onPressed: _player.pause,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(CupertinoIcons.restart),
                            iconSize: 32,
                            onPressed: () => _player.seek(Duration.zero),
                          );
                        }
                      },
                    ),
                    // Opens speed slider dialog
                    StreamBuilder<double>(
                      stream: _player.speedStream,
                      builder: (context, snapshot) => IconButton(
                        icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "倍速",
                            divisions: 10,
                            min: 0.5,
                            max: 3,
                            value: _player.speed,
                            stream: _player.speedStream,
                            onChanged: _player.setSpeed,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (text.isEmpty) ...[
                  const SizedBox(
                    height: 64,
                  ),
                  CupertinoButton.filled(
                    child: const Text('上传'),
                    onPressed: () {
                      var user = ref.read(userProvider);
                      if (user == null) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            content: const Text(
                              '请先登录',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('确认'),
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        print(ref.read(userProvider)?.toJson());
                        uploading = true;
                        setState(() {});
                        RecordApi.upload(
                                widget.path, ref.read(userProvider)?.id ?? 0)
                            .then(
                          (value) => setState(() {
                            _editingController.text = text = value;
                            uploading = false;
                          }),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
    );
  }
}

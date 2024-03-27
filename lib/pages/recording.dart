import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:storyhome/pages/player.dart';
import 'package:storyhome/pages/recorded.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  RecordingPageState createState() => RecordingPageState();
}

class RecordingPageState extends State<RecordingPage> {
  final RecorderController _controller = RecorderController();
  bool _isRecording = false;
  String _path = '';
  @override
  void initState() {
    if (player.playing) player.pause();
    permission();
    super.initState();
  }

  void permission() {
    _controller.checkPermission().then(
      (hasPermission) {
        if (!hasPermission) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: const Text('请允许麦克风权限'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _stopRecording() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: const Text(
            '确认停止录音？',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('确认'),
              onPressed: () {
                _controller.stop();
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => RecordedPage(
                      path: _path,
                    ),
                  ),
                );
              },
            ),
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () => Navigator.maybePop(context),
            )
          ],
        );
      },
    );
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await _controller.pause();
      setState(() {
        _isRecording = false;
      });
    } else {
      _path =
          '${(await getApplicationDocumentsDirectory()).path}/record${DateTime.now().microsecondsSinceEpoch}.m4a';
      await _controller.record(
        path: _path,
        androidEncoder: AndroidEncoder.aac,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        sampleRate: 44100,
        bitRate: 48000,
      );
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('录音'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: AudioWaveforms(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 2,
              ),
              recorderController: _controller,
              enableGesture: true,
              // shouldCalculateScrolledPosition: true,
              waveStyle: WaveStyle(
                durationLinesColor: Colors.red,
                scaleFactor: 50,
                backgroundColor: Colors.transparent,
                // color: Colors.white,
                // showHourInDuration: true,
                showDurationLabel: true,
                spacing: 8.0,
                // showBottom: true,
                // extendWaveform: true,
                showMiddleLine: true,
                gradient: ui.Gradient.linear(
                  const Offset(70, 0),
                  Offset(MediaQuery.of(context).size.width / 2, 0),
                  [
                    Colors.red.withOpacity(0.8),
                    Colors.red.shade900,
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 64,
              ),
              if (!_isRecording)
                IconButton(
                  icon: Icon(
                    _isRecording
                        ? Icons.pause_circle_outline
                        : Icons.radio_button_unchecked,
                    size: 64.0,
                  ),
                  onPressed: _toggleRecording,
                ),
              IconButton(
                icon: const Icon(
                  Icons.stop_circle_rounded,
                  size: 64.0,
                ),
                onPressed: _stopRecording,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

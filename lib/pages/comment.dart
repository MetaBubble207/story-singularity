import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isRecording = false;
  String? _recordedFilePath = 'aFullPath/myFile.m4a';
  Record record = Record();
  final List<String> _messages = [];

  Future<void> _startRecording() async {
    bool isRecording = true;
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: _recordedFilePath,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
    }
    // await record.start(path: 'audio');
    setState(() => _isRecording = isRecording);
  }

  Future<void> _stopRecording() async {
    await record.stop();
    setState(() {
      _isRecording = false;
    });
  }

  bool _showExtension = false;

  void toggleExtension() {
    setState(() {
      _showExtension = !_showExtension;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(primaryColor: Colors.red),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Chat'),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatBubble(
                        message: _messages[index],
                        isMe: true,
                      );
                    },
                  ),
// /ListView(
//                   children: [
//                     const ChatBubble(
//                       message: 'Hello',
//                       isMe: false,
//                     ),
//                     const ChatBubble(
//                       message: 'Hi',
//                       isMe: true,
//                     ),
//                     if (_recordedFilePath != null)
//                       ChatBubble(
//                         message: _recordedFilePath ?? '',
//                         isMe: true,
//                       ),
//                   ],
//                 ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.mic),
                        onPressed: () =>
                            _isRecording ? _stopRecording() : _startRecording(),
                        color: _isRecording ? Colors.red : Colors.grey,
                      ),
                      Expanded(
                        child: CupertinoTextField(
                          keyboardType: TextInputType.text,
                          controller: _textEditingController,
                          placeholder: '',
                          onSubmitted: (_) {
                            send();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.arrow_up_circle),
                        onPressed: () {
                          send();
                        },
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.add_circled),
                        onPressed: () {
                          toggleExtension();
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCirc,
                  height: _showExtension ? 200 : 0,
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: [
                      CupertinoButton(
                        child: Column(
                          children: const [
                            Icon(Icons.photo),
                            Text('相册'),
                          ],
                        ),
                        onPressed: () {},
                      ),
                      CupertinoButton(
                        child: Column(
                          children: const [
                            Icon(Icons.camera_alt),
                            Text('相机'),
                          ],
                        ),
                        onPressed: () {},
                      ),
// 其他菜单项
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void send() {
    String message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      _messages.insert(0, message);
      setState(() => _recordedFilePath = null);
      _textEditingController.clear();
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            const CircleAvatar(
              child: Text('A'),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isMe ? colorScheme.primaryContainer : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomLeft: isMe
                    ? const Radius.circular(16.0)
                    : const Radius.circular(0.0),
                bottomRight: isMe
                    ? const Radius.circular(0.0)
                    : const Radius.circular(16.0),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 16.0,
                  color: isMe ? colorScheme.onPrimaryContainer : Colors.black),
            ),
          ),
          if (isMe)
            const CircleAvatar(
              child: Text('B'),
            ),
        ],
      ),
    );
  }
}

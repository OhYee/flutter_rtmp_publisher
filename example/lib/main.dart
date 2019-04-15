import 'package:flutter/material.dart';

import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'language.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final RTMPCamera cameraController = RTMPCamera();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RTMP Publisher'),
        ),
        body: Column(
          children: <Widget>[
            RTMPCameraPreview(
              controller: this.cameraController,
            ),
            MyAppState(cameraController: cameraController),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends StatefulWidget {
  final RTMPCamera cameraController;

  MyAppState({Key key, this.cameraController}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {
  final TextEditingController textController =
      TextEditingController(text: "rtmp://10.240.169.163:19356/myapp/mystream");
  Language lang = language[0].useThis();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: textController,
            decoration: new InputDecoration(
              labelText: lang.address,
              // hintText: "RTMP Server address",
            ),
          ),
          languageChooser(),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: this.previewButton(),
                ),
                Expanded(
                  flex: 3,
                  child: this.streamButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget languageChooser() {
    return Container(
      child: Wrap(
        // spacing: 8.0,
        // runSpacing: 4.0,
        children: List.generate(
          language.length,
          (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  value: language[index].use, //当前状态
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      for (var l in language) {
                        l.use = false;
                      }
                      lang = language[index].useThis();
                    });
                  },
                ),
                Text(language[index].language),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget makeButton({IconData icon, String text, Function func}) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      // width: 150,
      height: 50,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Icon(icon),
            Text(text),
          ],
        ),
        onPressed: () {
          setState(func);
        },
      ),
    );
  }

  Widget previewButton() {
    if (!this.widget.cameraController.onPreview()) {
      return makeButton(
        icon: Icons.play_circle_filled,
        text: lang.startPreview,
        func: () {
          this.widget.cameraController.prepareAudio();
          this.widget.cameraController.prepareVideo();
          this.widget.cameraController.startPreview();
        },
      );
    } else {
      return makeButton(
        icon: Icons.pause_circle_filled,
        text: lang.stopPreview,
        func: () {
          this.widget.cameraController.stopPreview();
        },
      );
    }
  }

  Widget streamButton() {
    if (!this.widget.cameraController.isStreaming()) {
      return makeButton(
        icon: Icons.play_circle_filled,
        text: lang.startStream,
        func: () {
          this.widget.cameraController.startStream(this.textController.text);
        },
      );
    } else {
      return makeButton(
        icon: Icons.pause_circle_filled,
        text: lang.stopStream,
        func: () {
          this.widget.cameraController.stopStream();
        },
      );
    }
  }
}

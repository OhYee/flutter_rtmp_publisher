import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'language.dart';
import 'Dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final RTMPCamera cameraController = RTMPCamera();
  final StreamController<List<CameraSize>> streamController =
      StreamController<List<CameraSize>>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RTMP Publisher'),
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3 / 4,
              child: RTMPCameraPreview(
                controller: this.cameraController,
                createdCallback: (int id) {
                  this.cameraController.getResolutions().then((resolutionList) {
                    streamController.add(resolutionList);
                  });
                },
              ),
            ),
            Container(
              // height: 200,
              child: MyAppState(
                cameraController: cameraController,
                resolutionStream: streamController.stream,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyAppState extends StatefulWidget {
  final RTMPCamera cameraController;
  final Stream<List<CameraSize>> resolutionStream;
  MyAppState({Key key, this.cameraController, this.resolutionStream})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {
  final textController =
      TextEditingController(text: "rtmp://10.240.169.163:19356/myapp/mystream");

  final videoBitrateController = TextEditingController(text: "2560000");
  final fpsController = TextEditingController(text: "30");
  final audioBitrateController = TextEditingController(text: "128");
  final sampleRateController = TextEditingController(text: "44100");
  final usernameController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  bool hardwareController = false;
  bool echoCancelerController = false;
  bool noiseSuppressorController = false;

  Language lang = language[0].useThis();
  CameraSize size;

  bool onPreview = false;
  bool isStreaming = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextField(
            controller: textController,
            decoration: new InputDecoration(
              labelText: lang.address,
            ),
          ),
          languageChooser(),
          buttonArea(),
          settingArea(),
        ],
      ),
    );
  }

  makeToast({String text, String action, Function callback}) {
    // hide the last snackbar
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
      action: action != null
          ? SnackBarAction(
              label: action,
              onPressed: () => callback == null
                  ? Scaffold.of(context).hideCurrentSnackBar()
                  : callback,
            )
          : null,
    ));
  }

  Widget languageChooser() {
    return Container(
      child: Wrap(
        // spacing: 8.0,
        // runSpacing: 4.0,
        children: List.generate(
          language.length,
          (index) {
            return Checker(
              text: language[index].language,
              value: language[index].use,
              callbackFunc: (value) {
                setState(() {
                  for (var l in language) {
                    l.use = false;
                  }
                  lang = language[index].useThis();
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget makeTextField(String label, TextEditingController controller) {
    return Container(
      width: 150,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: new InputDecoration(
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }

  Widget settingArea() {
    return Container(
      alignment: Alignment(0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            lang.video,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ResolutionChooser(
            stream: this.widget.resolutionStream,
            lang: lang,
            callbackFunc: (CameraSize size) {
              this.size = size;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              makeTextField(lang.videoBitrate, videoBitrateController),
              makeTextField(lang.audioBitrate, audioBitrateController),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              makeTextField(lang.fps, fpsController),
              Checker(
                text: this.lang.hardwareRotation,
                value: this.hardwareController,
                callbackFunc: (value) {
                  setState(() {
                    this.hardwareController = value;
                  });
                },
              ),
            ],
          ),
          Text(
            this.lang.audio,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              makeTextField(lang.audioBitrate, audioBitrateController),
              makeTextField(lang.sampleRate, sampleRateController),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checker(
                text: this.lang.noiseSuppressor,
                value: this.noiseSuppressorController,
                callbackFunc: (value) {
                  setState(() {
                    this.noiseSuppressorController = value;
                  });
                },
              ),
              Checker(
                text: this.lang.echoCanceler,
                value: this.echoCancelerController,
                callbackFunc: (value) {
                  setState(() {
                    this.echoCancelerController = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonArea() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment(0, 0),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          this.previewButton(),
          this.streamButton(),
          makeButton(
              icon: Icons.switch_camera,
              text: lang.switchCamera,
              func: () {
                this.widget.cameraController.switchCamera();
              }),
        ],
      ),
    );
  }

  Future<bool> prepareEncode() async {
    return await this.widget.cameraController.prepareAudio(
              bitrate: int.parse(this.audioBitrateController.text),
              sampleRate: int.parse(this.sampleRateController.text),
              echoCanceler: this.echoCancelerController,
              noiseSuppressor: this.noiseSuppressorController,
            ) &&
        await this.widget.cameraController.prepareVideo(
              width: this.size.width,
              height: this.size.height,
              fps: int.parse(this.fpsController.text),
              bitrate: int.parse(this.videoBitrateController.text),
              hardwareRotation: this.hardwareController,
            );
  }

  Widget makeButton({IconData icon, String text, Function func}) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      constraints: BoxConstraints(maxWidth: 170),
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
          func();
        },
      ),
    );
  }

  Widget previewButton() {
    if (!this.onPreview) {
      return makeButton(
        icon: Icons.play_circle_filled,
        text: lang.startPreview,
        func: () async {
          if (this.size == null) {
            makeToast(text: lang.errorResolutionFirst, action: lang.gotIt);
          } else {
            if (await this.prepareEncode()) {
              await this.widget.cameraController.startPreview();
              this.widget.cameraController.onPreview().then((preview) {
                setState(() {
                  this.onPreview = preview;
                });
              });
            } else {
              makeToast(text: "Error");
            }
          }
        },
      );
    } else {
      return makeButton(
        icon: Icons.pause_circle_filled,
        text: lang.stopPreview,
        func: () async {
          await this.widget.cameraController.stopPreview();
          this.widget.cameraController.onPreview().then((preview) {
            setState(() {
              this.onPreview = preview;
            });
          });
        },
      );
    }
  }

  Widget streamButton() {
    if (!this.isStreaming) {
      return makeButton(
        icon: Icons.play_circle_filled,
        text: lang.startStream,
        func: () async {
          if (await this.widget.cameraController.onPreview() == false ||
              await this.prepareEncode()) {
            await this
                .widget
                .cameraController
                .startStream(this.textController.text);

            this.widget.cameraController.isStreaming().then((streaming) {
              setState(() {
                this.isStreaming = streaming;
              });
            });
          } else {
            makeToast(text: "Error!");
          }
        },
      );
    } else {
      return makeButton(
        icon: Icons.pause_circle_filled,
        text: lang.stopStream,
        func: () async {
          await this.widget.cameraController.stopStream();
          this.widget.cameraController.isStreaming().then((streaming) {
            setState(() {
              this.isStreaming = streaming;
            });
          });
        },
      );
    }
  }
}

/* 
  Dropdown
*/

class ResolutionChooser extends StatefulWidget {
  final Stream<List<CameraSize>> stream;
  final Language lang;
  final CameraSizeCallback callbackFunc;

  ResolutionChooser({
    Key key,
    this.stream,
    this.lang,
    this.callbackFunc,
  }) : super(key: key);

  @override
  _ResolutionChooserState createState() => _ResolutionChooserState();
}

class _ResolutionChooserState extends State<ResolutionChooser> {
  List<CameraSize> resolutionList;
  CameraSize size;
  int selected;

  StreamSubscription<List<CameraSize>> listener;

  @override
  void initState() {
    super.initState();
    listener = this.widget.stream.listen((rl) {
      setState(() {
        this.resolutionList = rl;
        if (rl.length > 0) {
          this.selected = 0;
          this.widget.callbackFunc(rl[0]);
        }
      });
    });
  }

  @override
  void dispose() {
    if (this.listener != null) {
      this.listener.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this.resolutionList == null
        ? Text(this.widget.lang.resolutionIsLoding)
        : DropdownButtonHideUnderline(
            child: DropdownButton(
              items: List.generate(this.resolutionList.length, (index) {
                CameraSize resolution = this.resolutionList[index];
                return DropdownMenuItem(
                  value: index,
                  child: new Text("${resolution.width}×${resolution.height}"),
                );
              }),
              hint: Text(this.widget.lang.resolutionFirst),
              value: selected,
              onChanged: (int i) {
                if (this.widget.callbackFunc != null) {
                  this.widget.callbackFunc(this.resolutionList[i]);
                }
                setState(() {
                  this.selected = i;
                });
              },
            ),
          );
  }
}

class Checker extends StatefulWidget {
  final Function callbackFunc;
  final String text;
  final bool value;
  Checker({Key key, this.callbackFunc, this.text, this.value})
      : super(key: key);

  @override
  _CheckerState createState() => _CheckerState(value: value);
}

class _CheckerState extends State<Checker> {
  bool value;

  _CheckerState({this.value}) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
          value: this.widget.value, //当前状态
          onChanged: (value) {
            if (this.widget.callbackFunc != null) {
              this.widget.callbackFunc(value);
            }
          },
        ),
        Text(this.widget.text),
      ],
    );
  }
}

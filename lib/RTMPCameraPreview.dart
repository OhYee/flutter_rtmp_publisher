import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'RTMPCamera.dart';

// class RTMPCameraPreview extends StatelessWidget {
//   final RTMPCamera controller;
//   const RTMPCameraPreview({Key key, this.controller}) : super(key: key);

//   Future<Widget> waitWidget() async {
//     int id = await this.controller.getId();
//     print("Build preview on camera id $id.");
//     return AndroidView(
//       viewType: 'flutter_rtmp_publisher/RTMPCameraPreview',
//       creationParams: id,
//       creationParamsCodec: StandardMessageCodec(),
//       onPlatformViewCreated: _onPlatformViewCreated,
//     );
//   }

//   FutureBuilder<Widget> buildFutureBuilder() {
//     return FutureBuilder<Widget>(
//       builder: (context, AsyncSnapshot<Widget> waitId) {
//         if (waitId.connectionState == ConnectionState.active ||
//             waitId.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (waitId.connectionState == ConnectionState.done) {
//           if (waitId.hasError) {
//             return Text("Error: Controller id error.");
//           } else if (waitId.hasData) {
//             return waitId.data;
//           }
//         }
//       },
//       future: waitWidget(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     if (defaultTargetPlatform != TargetPlatform.android) {
//       child = Text("$defaultTargetPlatform is not yet supported by the plugin");
//     } else {
//       if (this.controller == null) {
//         child = Text("Controller not set.");
//       } else {
//         child = buildFutureBuilder();
//       }
//     }

//     return Container(
//       width: 200,
//       height: 200,
//       child: child,
//     );
//   }

//   @override
//   void dispose() {
//     // super.dispose();
//     this.controller.unsetView();
//   }

//   void _onPlatformViewCreated(int id) {
//     print("Preview created $id");
//   }
// }




class RTMPCameraPreview extends StatefulWidget {
  // static final _statefulKey = new GlobalKey(debugLabel: 'RTMPCameraPreview');
  final RTMPCamera controller;
  const RTMPCameraPreview({Key key, this.controller}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RTMPCameraPreviewState();
}

class _RTMPCameraPreviewState extends State<RTMPCameraPreview> {
  Future<Widget> waitWidget() async {
    int id = await this.widget.controller.getId();
    print("Build preview on camera id $id.");
    return AndroidView(
      viewType: 'flutter_rtmp_publisher/RTMPCameraPreview',
      creationParams: id,
      creationParamsCodec: StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  FutureBuilder<Widget> buildFutureBuilder() {
    return FutureBuilder<Widget>(
      builder: (context, AsyncSnapshot<Widget> waitId) {
        if (waitId.connectionState == ConnectionState.active ||
            waitId.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (waitId.connectionState == ConnectionState.done) {
          if (waitId.hasError) {
            return Text("Error: Controller id error.");
          } else if (waitId.hasData) {
            return waitId.data;
          }
        }
      },
      future: waitWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (defaultTargetPlatform != TargetPlatform.android) {
      child = Text("$defaultTargetPlatform is not yet supported by the plugin");
    } else {
      if (this.widget.controller == null) {
        child = Text("Controller not set.");
      } else {
        child = buildFutureBuilder();
      }
    }

    return Container(
      width: 500,
      height: 400,
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    this.widget.controller.unsetView();
  }

  void _onPlatformViewCreated(int id) {
    print("Preview created $id");
  }
}

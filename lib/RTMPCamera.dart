import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel =
    const MethodChannel('flutter_rtmp_publisher/method');

class RTMPCamera {
  Future<int> _id = _channel.invokeMethod("NewRTMPCamera");
  bool _isStreaming = false;
  bool _onPreview = false;
  MethodChannel _methodChannel;

  RTMPCamera() {
    _id.then((id) {
      print("Init RTMPCamera id: $id");
      _methodChannel =
          MethodChannel('flutter_rtmp_publisher/method/RTMPCamera_$id');
    });
  }

  Future<Null> unsetView() async {
    return await _methodChannel.invokeMethod("unsetView");
  }

  Future<Null> dispose() async {
    return await _methodChannel.invokeMethod("dispose");
  }

  Future<int> getId() async {
    return this._id;
  }

  Future<bool> prepareVideo() async {
    return await _methodChannel.invokeMethod("prepareVideo");
  }

  Future<bool> prepareAudio() async {
    return await _methodChannel.invokeMethod("prepareAudio");
  }

  Future<Null> startPreview() async {
    if (this._onPreview == false) {
      _methodChannel.invokeMethod("startPreview");
      this._onPreview = true;
    } else {
      print("Ignore startPreview.");
    }
  }

  Future<Null> stopPreview() async {
    if (this._onPreview == true) {
      _methodChannel.invokeMethod("stopPreview");
      _onPreview = false;
    } else {
      print("Ignore stopPreview.");
    }
  }

  Future<Null> startStream(String url) async {
    if (this._isStreaming == false) {
      _methodChannel.invokeMethod("startStream", url);
      this._isStreaming = true;
    } else {
      print("Ignore startStream.");
    }
  }

  Future<Null> stopStream() async {
    if (this._isStreaming == true) {
      _methodChannel.invokeMethod("stopStream");
      this._isStreaming = false;
    } else {
      print("Ignore stopStream.");
    }
  }

  bool isStreaming() {
    return this._isStreaming;
  }

  bool onPreview() {
    return this._onPreview;
  }
}

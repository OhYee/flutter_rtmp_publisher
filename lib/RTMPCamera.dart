import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel =
    const MethodChannel('flutter_rtmp_publisher/method');

class CameraSize {
  int width;
  int height;
  CameraSize(this.width, this.height);
}

typedef void CameraSizeCallback(CameraSize size);

class RTMPCamera {
  Future<int> _id = _channel.invokeMethod("NewRTMPCamera");
  // bool _isStreaming = false;
  // bool _onPreview = false;
  MethodChannel _methodChannel;

  RTMPCamera() {
    _id.then((id) {
      print("Init RTMPCamera id: $id");
      _methodChannel =
          MethodChannel('flutter_rtmp_publisher/method/RTMPCamera_$id');
    });
  }

  Future<Null> unsetView() async {
    await _methodChannel.invokeMethod("unsetView");
  }

  Future<Null> dispose() async {
    await _methodChannel.invokeMethod("dispose");
  }

  Future<int> getId() async {
    return this._id;
  }

  Future<List<CameraSize>> getResolutions() async {
    List<dynamic> res = await _methodChannel.invokeMethod("getResolutions");
    List<CameraSize> list = List.generate(res.length, (index) {
      return CameraSize(res[index]["width"], res[index]["height"]);
    });
    return list;
  }

  Future<bool> prepareVideo({
    int width = 640,
    int height = 480,
    int fps = 30,
    int bitrate = 2500 * 1024,
    bool hardwareRotation = false,
    int rotation = 90,
  }) async {
    return await _methodChannel.invokeMethod("prepareVideo", {
      "width": width,
      "height": height,
      "fps": fps,
      "bitrate": bitrate,
      "hardwareRotation": hardwareRotation,
      "rotation": rotation,
    });
  }

  Future<bool> prepareAudio({
    int bitrate: 128,
    int sampleRate: 44100,
    bool isStereo: true,
    bool echoCanceler: false,
    bool noiseSuppressor: false,
  }) async {
    return await _methodChannel.invokeMethod("prepareAudio", {
      "bitrate": bitrate,
      "sampleRate": sampleRate,
      "isStereo": isStereo,
      "echoCanceler": echoCanceler,
      "noiseSuppressor": noiseSuppressor,
    });
  }

  Future<Null> startPreview() async {
    if (await this.onPreview() == false) {
      await _methodChannel.invokeMethod("startPreview");
    } else {
      print("Ignore startPreview.");
    }
  }

  Future<Null> stopPreview() async {
    if (await this.onPreview() == true) {
      await _methodChannel.invokeMethod("stopPreview");
      // this._onPreview = await _methodChannel.invokeMethod("isOnPreview");
    } else {
      print("Ignore stopPreview.");
    }
  }

  Future<Null> startStream(String url) async {
    if (await this.isStreaming() == false) {
      await _methodChannel.invokeMethod("startStream", url);
      // this._isStreaming = await _methodChannel.invokeMethod("isStreaming");
    } else {
      print("Ignore startStream.");
    }
  }

  Future<Null> stopStream() async {
    if (await this.isStreaming() == true) {
      await _methodChannel.invokeMethod("stopStream");
      // this._isStreaming = await _methodChannel.invokeMethod("isStreaming");
    } else {
      print("Ignore stopStream.");
    }
  }

  Future<Null> switchCamera() async {
    _methodChannel.invokeMethod("switchCamera");
  }

  Future<bool> isStreaming() async {
    return await _methodChannel.invokeMethod("isStreaming");
  }

  Future<bool> onPreview() async {
    return await _methodChannel.invokeMethod("isOnPreview");
  }
}

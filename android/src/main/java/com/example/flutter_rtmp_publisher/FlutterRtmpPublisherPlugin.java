package com.example.flutter_rtmp_publisher;

import java.util.List;
import java.util.ArrayList;

import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterRtmpPublisherPlugin */
public class FlutterRtmpPublisherPlugin implements MethodCallHandler {
    static List<RTMPCamera> cameraList = new ArrayList<RTMPCamera>();

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        RTMPCamera.flutterRegistrar = registrar;

        registrar.platformViewRegistry().registerViewFactory("flutter_rtmp_publisher/RTMPCameraPreview",
                new RTMPCameraPreviewFactory(registrar.messenger()));

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_rtmp_publisher/method");
        channel.setMethodCallHandler(new FlutterRtmpPublisherPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
        case "NewRTMPCamera": {
            Integer id = cameraList.size();
            cameraList.add(new RTMPCamera(id));
            result.success(id);
            break;
        }
        case "DisposeRTMPCamera": {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
            break;
        }
        default: {
            Log.i("RTMP Publisher Plugin", "Method call error");
            result.notImplemented();
            break;
        }
        }
    }
}

package com.example.flutter_rtmp_publisher;

import android.content.Context;
import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class RTMPCameraPreviewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public RTMPCameraPreviewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new RTMPCameraPreview(context, messenger, id, o);
    }
}

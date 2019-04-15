package com.example.flutter_rtmp_publisher;

import android.view.TextureView;
import android.view.TextureView.SurfaceTextureListener;
import android.content.Context;
import android.graphics.SurfaceTexture;
import android.view.View;
import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class RTMPCameraPreview implements PlatformView, TextureView.SurfaceTextureListener {
    TextureView textureView;

    RTMPCameraPreview(Context context, BinaryMessenger messenger, int id, Object o) {
        Integer cameraId = Integer.valueOf(o.toString());
        Log.i("RTMPCameraPreview", "Create preview from camera " + cameraId.toString());
        this.textureView = new TextureView(context);
        this.textureView.setSurfaceTextureListener(this);
        FlutterRtmpPublisherPlugin.cameraList.get(cameraId).setView(this.textureView);
        Log.i("RTMPCameraPreview", "TextureView created.");
    }

    @Override
    public void dispose() {
    }

    @Override
    public View getView() {
        return this.textureView;
    }

    @Override
    public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
    }

    @Override
    public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
    }

    @Override
    public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
        return false;
    }

    @Override
    public void onSurfaceTextureUpdated(SurfaceTexture surface) {
    }
}
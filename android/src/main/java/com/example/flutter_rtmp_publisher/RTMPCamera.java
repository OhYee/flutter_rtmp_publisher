package com.example.flutter_rtmp_publisher;

import com.pedro.rtplibrary.rtmp.RtmpCamera1;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.view.TextureView;
import android.util.Log;
import android.view.Gravity;
import android.widget.FrameLayout;

import java.lang.Object;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.function.Function;

import com.pedro.rtplibrary.rtmp.RtmpCamera1;
import net.ossrs.rtmp.ConnectCheckerRtmp;

public class RTMPCamera implements MethodCallHandler, ConnectCheckerRtmp {
    static Registrar flutterRegistrar;
    final Integer id;
    final MethodChannel methodChannel;

    RtmpCamera1 camera;
    TextureView textureView;

    RTMPCamera(int id) {
        this.id = id;
        Log.i("RTMPCamera", "Init camera id = " + this.id.toString());
        methodChannel = new MethodChannel(flutterRegistrar.messenger(),
                "flutter_rtmp_publisher/method/RTMPCamera_" + this.id.toString());
        methodChannel.setMethodCallHandler(this);
    }

    void setView(TextureView textureView) {
        this.textureView = textureView;
        this.camera = new RtmpCamera1(textureView, this);
        Log.i("RTMPCamera", "Create camera id = " + this.id.toString());
    }

    /*
     * Flutter Method
     */
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        try {
            String methodName = call.method;
            Log.i("RTMPCamera", "Method call: " + methodName);
            Method method = RTMPCamera.class.getMethod(methodName, Object.class);
            method.setAccessible(true);
            result.success(method.invoke(this, call.arguments));
        } catch (Exception e) {
            Log.i("RTMPCamera", "Method error. " + e.toString());
            result.notImplemented();
        }
    }

    // RTMPCameraPreview destroyed
    void unsetView() {
        this.dispose();
    }

    // Destroy RTMPCamera
    void dispose() {
        if (this.camera != null) {
            this.camera.stopStream();
            this.camera.stopPreview();
            this.camera = null;
        }
    }

    public void startPreview(Object args) {
        if (this.camera != null) {
            camera.startPreview();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
    }

    public void stopPreview(Object args) {
        if (this.camera != null) {
            camera.stopPreview();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
    }

    public boolean prepareVideo(Object args) {
        if (this.camera != null) {
            return camera.prepareVideo();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
            return false;
        }

    }

    public boolean prepareAudio(Object args) {
        if (this.camera != null) {
            return camera.prepareAudio();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
            return false;
        }
    }

    public void startStream(Object args) {
        String url = args.toString();
        if (this.camera != null) {
            Log.i("RTMPCamera", "Start stream: " + url);
            try {
                camera.startStream(url);
            } catch (Exception e) {
                Log.e("RTMPCamera", e.toString());
            }
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }

    }

    public void stopStream(Object args) {
        if (this.camera != null) {
            camera.stopStream();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }

    }

    public boolean isStreaming(Object args) {
        if (this.camera != null) {
            return camera.isStreaming();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
            return false;
        }
    }

    // public boolean isPreviewing(Object args) {
    // return camera.isStreaming();
    // }

    @Override
    public void onConnectionSuccessRtmp() {
        Log.i("RTMP", "Connect successful.");
    }

    @Override
    public void onConnectionFailedRtmp(final String reason) {
        Log.i("RTMP", "Connect failed.");
    }

    @Override
    public void onDisconnectRtmp() {
        Log.i("RTMP", "Connect disconnect.");

    }

    @Override
    public void onAuthErrorRtmp() {
        Log.i("RTMP", "Connect author error.");

    }

    @Override
    public void onAuthSuccessRtmp() {
        Log.i("RTMP", "Connect author successful.");
    }
}
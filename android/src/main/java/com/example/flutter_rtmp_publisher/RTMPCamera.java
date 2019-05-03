package com.example.flutter_rtmp_publisher;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.view.TextureView;
import android.util.Log;
import android.view.Gravity;
import android.widget.FrameLayout;
import android.hardware.Camera;

import java.lang.Object;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.HashMap;
import java.util.function.Function;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import android.util.Size;

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
            Method method = RTMPCamera.class.getDeclaredMethod(methodName, Object.class);
            method.setAccessible(true);
            Object res = method.invoke(this, call.arguments);
            result.success(res);
        } catch (Exception e) {
            Log.i("RTMPCamera", "Method error. " + e.toString());
            result.notImplemented();
        }
    }

    // RTMPCameraPreview destroyed
    public void unsetView(Object args) {
        this.dispose(args);
    }

    // Destroy RTMPCamera
    public void dispose(Object args) {
        if (this.camera != null) {
            if (this.camera.isStreaming()) {
                this.camera.stopStream();
            }
            if (this.camera.isOnPreview()) {
                this.camera.stopPreview();
            }
            this.camera = null;
        }
    }

    public void setAuthorization(Object args) {
        if (this.camera != null) {
            try {
                Class cls = args.getClass();
                String username = cls.getField("user").get(args).toString();
                String password = cls.getField("passwd").get(args).toString();
                camera.setAuthorization(username, password);
            } catch (Exception e) {
                Log.e("RTMPCamera", "Arguments error " + e.toString());
            }
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
    }

    public List<Map<String, Integer>> getResolutions(Object args) {
        List<Map<String, Integer>> list = new ArrayList<Map<String, Integer>>();
        if (this.camera != null) {
            for (Camera.Size size : camera.getResolutionsBack()) {
                Map<String, Integer> map = new HashMap();
                map.put("width", size.width);
                map.put("height", size.height);
                list.add(map);
            }
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
        return list;
    }

    public boolean prepareVideo(Object args) {
        if (this.camera != null) {
            HashMap map = (HashMap) args;
            Integer width = (Integer) map.get("width");
            Integer height = (Integer) map.get("height");
            Integer fps = (Integer) map.get("fps");
            Integer bitrate = (Integer) map.get("bitrate");
            Boolean hardwareRotation = (Boolean) map.get("hardwareRotation");
            Integer rotation = (Integer) map.get("rotation");
            Log.i("RTMPCamera",
                    String.format("%dx%d @%d %d %b %d", width, height, fps, bitrate, hardwareRotation, rotation));
            return camera.prepareVideo(width, height, fps, bitrate, hardwareRotation, rotation);
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
        return false;
    }

    public boolean prepareAudio(Object args) {
        if (this.camera != null) {
            HashMap map = (HashMap) args;
            Integer bitrate = (Integer) map.get("bitrate");
            Integer sampleRate = (Integer) map.get("sampleRate");
            Boolean isStereo = (Boolean) map.get("isStereo");
            Boolean echoCanceler = (Boolean) map.get("echoCanceler");
            Boolean noiseSuppressor = (Boolean) map.get("noiseSuppressor");
            Log.i("RTMPCamera",
                    String.format("%d %d %b %b %b", bitrate, sampleRate, isStereo, echoCanceler, noiseSuppressor));
            return camera.prepareAudio(bitrate, sampleRate, isStereo, echoCanceler, noiseSuppressor);
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
        return false;
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

    public boolean isFrontCamera() {
        if (this.camera != null) {
            return camera.isFrontCamera();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
        }
        return false;
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

    public boolean isOnPreview(Object args) {
        if (this.camera != null) {
            return camera.isOnPreview();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
            return false;
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

    public void switchCamera(Object args) {
        if (this.camera != null) {
            this.camera.switchCamera();
        } else {
            Log.e("RTMPCamera", "Camera without a textureView");
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
package com.example.shahajjo;

import android.content.Context;
import android.content.Intent;
import android.provider.Settings;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.view.KeyEvent;

public class VolumeButtonPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private static final String CHANNEL = "com.example.shahajjo/volume_button";
    private MethodChannel channel;
    private EventChannel eventChannel;
    private Context context;
    private EventChannel.EventSink eventSink;

    @Override
    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding binding) {
        context = binding.getApplicationContext();
        channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);
        
        eventChannel = new EventChannel(binding.getBinaryMessenger(), CHANNEL + "_events");
        eventChannel.setStreamHandler(this);

        VolumeAccessibilityService.setCallback(keyCode -> {
            if (eventSink != null) {
                String buttonType = keyCode == KeyEvent.KEYCODE_VOLUME_UP ? "up" : "down";
                eventSink.success(buttonType);
            }
        });
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("checkAccessibilityPermission")) {
            boolean isEnabled = isAccessibilityServiceEnabled();
            result.success(isEnabled);
        } else if (call.method.equals("openAccessibilitySettings")) {
            Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private boolean isAccessibilityServiceEnabled() {
        String service = context.getPackageName() + "/" + VolumeAccessibilityService.class.getCanonicalName();
        String enabledServices = Settings.Secure.getString(
            context.getContentResolver(),
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        );
        return enabledServices != null && enabledServices.contains(service);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        this.eventSink = null;
    }

    @Override
    public void onDetachedFromEngine(FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }
}
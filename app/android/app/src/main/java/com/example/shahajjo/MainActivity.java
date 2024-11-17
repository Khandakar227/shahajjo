package com.example.shahajjo;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "volume_button_channel";
    private static final String EVENT_CHANNEL = "volume_button_events";
    private static final String TAG = "MainActivity";

    private BroadcastReceiver volumeReceiver;
    private EventChannel.EventSink volumeEventSink;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Register receiver for volume events from AccessibilityService
        registerVolumeReceiver();

        // Ensure Accessibility Service is enabled
        checkAccessibilityServiceEnabled();
    }

    private void checkAccessibilityServiceEnabled() {
        // Launch the Accessibility settings screen if the service is not enabled
        if (!isAccessibilityServiceEnabled()) {
            Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
            startActivity(intent);
        }
    }

    private boolean isAccessibilityServiceEnabled() {
        String enabledServices = Settings.Secure.getString(
                getContentResolver(),
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        );
        return enabledServices != null && enabledServices.contains(VolumeAccessibilityService.class.getName());
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Flutter MethodChannel for enabling AccessibilityService manually
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "checkAccessibilityService":
                            checkAccessibilityServiceEnabled();
                            result.success(null);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });

        // Flutter EventChannel to send volume button events to Dart
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        volumeEventSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        volumeEventSink = null;
                    }
                });
    }

    private void registerVolumeReceiver() {
        volumeReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (volumeEventSink != null) {
                    switch (intent.getAction()) {
                        case "VOLUME_UP_ACTION":
                            Log.d(TAG, "Volume Up detected");
                            volumeEventSink.success("VOLUME_UP");
                            break;

                        case "VOLUME_DOWN_ACTION":
                            Log.d(TAG, "Volume Down detected");
                            volumeEventSink.success("VOLUME_DOWN");
                            break;
                    }
                }
            }
        };

        IntentFilter filter = new IntentFilter();
        filter.addAction("VOLUME_UP_ACTION");
        filter.addAction("VOLUME_DOWN_ACTION");
        registerReceiver(volumeReceiver, filter);
    }

    @Override
    protected void onDestroy() {
        if (volumeReceiver != null) {
            unregisterReceiver(volumeReceiver);
        }
        super.onDestroy();
    }
}

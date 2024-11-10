package com.example.shahajjo;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends VolumeButtonHandler {
    private static final String CHANNEL = "flutter_channel";
    private NotificationSecrets notificationSecrets;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        notificationSecrets = new NotificationSecrets(this);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> notificationSecrets.handleMethodCall(call, result));
    }
}
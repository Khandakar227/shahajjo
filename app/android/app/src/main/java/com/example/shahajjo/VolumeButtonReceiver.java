package com.example.shahajjo;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.view.KeyEvent;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

public class VolumeButtonReceiver extends BroadcastReceiver {
    private static final String CHANNEL = "volume_button";
    private FlutterEngine flutterEngine;

    public VolumeButtonReceiver(FlutterEngine flutterEngine) {
        this.flutterEngine = flutterEngine;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        KeyEvent event = intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT);
        if (event != null && event.getAction() == KeyEvent.ACTION_DOWN) {
            int keyCode = event.getKeyCode();
            if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                        .invokeMethod("volumeButton", "down");
            } else if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                        .invokeMethod("volumeButton", "up");
            }
        }
    }
}
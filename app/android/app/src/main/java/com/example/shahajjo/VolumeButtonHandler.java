package com.example.shahajjo;

import android.view.KeyEvent;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class VolumeButtonHandler extends FlutterActivity {
    private static final String CHANNEL = "volume_button";

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                    .invokeMethod("volumeButton", "down");
        } else if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                    .invokeMethod("volumeButton", "up");
        }
        return super.onKeyDown(keyCode, event);
    }
}
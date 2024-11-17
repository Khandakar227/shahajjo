package com.example.shahajjo;

import android.accessibilityservice.AccessibilityService;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.accessibility.AccessibilityEvent;
import android.util.Log;

public class VolumeAccessibilityService extends AccessibilityService {
    private static final String FLUTTER_EVENT_CHANNEL = "com.example.shahajjo/volume_button";
    private static VolumeButtonCallback volumeButtonCallback;
    private static final String TAG = "VolumeAccessibilityService";

    public interface VolumeButtonCallback {
        void onVolumeButtonPress(int keyCode);
    }

    public static void setCallback(VolumeButtonCallback callback) {
        volumeButtonCallback = callback;
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        // Not used but must be implemented
        Log.d(TAG, "onAccessibilityEvent: " + event);
    }

    @Override
    public void onInterrupt() {
        // Not used but must be implemented
        Log.d(TAG, "onInterrupt");
    }

    @Override
    protected boolean onKeyEvent(KeyEvent event) {
        int keyCode = event.getKeyCode();
        Log.d(TAG, "onKeyEvent: " + keyCode);
        
        if ((keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) 
            && event.getAction() == KeyEvent.ACTION_DOWN) {
            
            if (volumeButtonCallback != null) {
                volumeButtonCallback.onVolumeButtonPress(keyCode);
            }
        }
        return super.onKeyEvent(event);
    }

    @Override
    public void onServiceConnected() {
        super.onServiceConnected();
    }
}
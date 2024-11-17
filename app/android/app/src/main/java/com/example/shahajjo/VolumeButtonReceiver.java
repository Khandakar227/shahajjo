package com.example.shahajjo;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;

public class VolumeButtonReceiver extends BroadcastReceiver {
    private static final String TAG = "VolumeButtonReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "Received intent: " + intent.getAction());
        if ("android.intent.action.MEDIA_BUTTON".equals(intent.getAction())) {
            Log.d(TAG, "Media button pressed");
            KeyEvent keyEvent = intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT);
            if (keyEvent != null && keyEvent.getAction() == KeyEvent.ACTION_DOWN) {
                switch (keyEvent.getKeyCode()) {
                    case KeyEvent.KEYCODE_VOLUME_UP:
                        onVolumeUp(context);
                        break;
                    case KeyEvent.KEYCODE_VOLUME_DOWN:
                        onVolumeDown(context);
                        break;
                }
            }
        }
    }

    private void onVolumeUp(Context context) {
        Log.d(TAG, "Volume Up pressed");
        Intent volumeIntent = new Intent("VOLUME_UP_ACTION");
        context.sendBroadcast(volumeIntent);
    }

    private void onVolumeDown(Context context) {
        Log.d(TAG, "Volume Down pressed");
        Intent volumeIntent = new Intent("VOLUME_DOWN_ACTION");
        context.sendBroadcast(volumeIntent);
    }
}

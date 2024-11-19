package com.example.shahajjo;

import android.accessibilityservice.AccessibilityService;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;
import android.view.accessibility.AccessibilityEvent;
import android.content.Context;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngineCache;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.Collections;


public class VolumeAccessibilityService extends AccessibilityService {
    private FlutterEngine flutterEngine;
    private MethodChannel methodChannel;
    private static final String CHANNEL_NAME = "com.example.shahajjo/volume_button_channel";
    private static final String TAG = "VolumeAccessibilityService";

    @Override
    public void onCreate() {
        super.onCreate();

        // Initialize FlutterEngine and MethodChannel
        // flutterEngine = new FlutterEngine(this);
        // flutterEngine.getDartExecutor().executeDartEntrypoint(
        //     DartExecutor.DartEntrypoint.createDefault()
        // );

        flutterEngine = FlutterEngineCache.getInstance().get("1");

        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        // Log.d(TAG, "onAccessibilityEvent: " + event.toString());
    }

    @Override
    public void onInterrupt() {
        Log.d(TAG, "onInterrupt");
    }

    @Override
    protected boolean onKeyEvent(KeyEvent event) {
        // Log.d(TAG, "onKeyEvent: " + event.toString());
        // if (event.getAction() == KeyEvent.ACTION_DOWN) {
            switch(event.getKeyCode()) {
                case KeyEvent.KEYCODE_VOLUME_UP:
                    Log.d(TAG, "Volume UP");
                    emitVolumeButtonEvent("VOLUME_UP");
                    return false;
                case KeyEvent.KEYCODE_VOLUME_DOWN:
                    Log.d(TAG, "Volume DOWN");
                    emitVolumeButtonEvent("VOLUME_DOWN");
                    return false;
            // }
        }

        return super.onKeyEvent(event);
    }

    private void emitVolumeButtonEvent(String action) {
        // Intent intent = new Intent("com.example.VOLUME_BUTTON_PRESSED");
        // intent.putExtra("action", action);
        // sendBroadcast(intent);
        if(methodChannel == null)
            methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
            
        if(methodChannel != null) {
            methodChannel.invokeMethod("onVolumeButtonEvent", Collections.singletonMap("action", action));
            Log.d(TAG, "Emitting volume button event: " + action);
        }
    }

    public void accessDatabase() {
        // Get the database path
        String databasePath = getApplicationContext().getDatabasePath("shahajjo.db").getAbsolutePath();
        // Open the database (make sure the mode is appropriate: read/write or readonly)
        SQLiteDatabase db = SQLiteDatabase.openDatabase(databasePath, null, SQLiteDatabase.OPEN_READWRITE);
        // Perform a query
        Cursor cursor = db.rawQuery("SELECT * FROM sos_contacts", null);
        // Iterate through the results
        if (cursor.moveToFirst()) {
            do {
                String columnValue = cursor.getString(cursor.getColumnIndex("phoneNumber"));
                Log.d(TAG, "Value: " + columnValue);
            } while (cursor.moveToNext());
        }
    
        // Close the cursor and database
        cursor.close();
        db.close();
    }

}

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
import android.location.LocationManager;
import android.location.Location;
import android.content.pm.PackageManager;
import android.content.SharedPreferences;
import android.os.Vibrator;

import java.util.Collections;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VolumeAccessibilityService extends AccessibilityService {
    private FlutterEngine flutterEngine;
    private MethodChannel methodChannel;
    private static final String CHANNEL_NAME = "com.example.shahajjo/volume_button_channel";
    private static final String TAG = "VolumeAccessibilityService";
    private static long timeAfterLastVolumeButtonPress = 0;
    private SmsService smsService = new SmsService();

    private static final List<Integer> PATTERN = List.of(
        KeyEvent.KEYCODE_VOLUME_DOWN,
        KeyEvent.KEYCODE_VOLUME_DOWN,
        KeyEvent.KEYCODE_VOLUME_DOWN,
        KeyEvent.KEYCODE_VOLUME_DOWN,
        KeyEvent.KEYCODE_VOLUME_DOWN,
        KeyEvent.KEYCODE_VOLUME_DOWN
    );

    private static int currentIndex = 0;
    private static long TIMEOUT = 800;

    private LocationManager locationManager;


    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize FlutterEngine and MethodChannel
        flutterEngine = FlutterEngineCache.getInstance().get("1");
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
    }

    @Override
    public void onServiceConnected() {
        super.onServiceConnected();
        // Initialize LocationManager
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
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
        int keyCode = event.getKeyCode();
        
        if (KeyEvent.KEYCODE_VOLUME_UP == keyCode || KeyEvent.KEYCODE_VOLUME_DOWN == keyCode) {
            // Check if interval between each volume button press is less than 1 second
            Log.d(TAG, "Volume button pressed: " + keyCode);
            if(timeAfterLastVolumeButtonPress == 0) timeAfterLastVolumeButtonPress = System.currentTimeMillis();
            else {
                Log.d(TAG, "Time between volume button press: " + (System.currentTimeMillis() - timeAfterLastVolumeButtonPress));
                if(System.currentTimeMillis() - timeAfterLastVolumeButtonPress > TIMEOUT) {
                    currentIndex = 0;
                    Log.d(TAG, "TIMEOUT, Resetting current index");
                }
            }
            
            timeAfterLastVolumeButtonPress = System.currentTimeMillis();

            if(keyCode == PATTERN.get(currentIndex)) currentIndex++;
            else currentIndex = 0;
            
            Log.d(TAG, "Incremented Current index: " + currentIndex);

            // Pattern matched
            if(currentIndex == PATTERN.size()) {
                currentIndex = 0;
                Log.d(TAG, "Volume button pattern matched");
                // Send sms and push notification to sos contacts
                sendSmsToSosContacts();
                emitVolumeButtonEvent("VOLUME_PATTERN");
                return false;
            }
        }
        
        return super.onKeyEvent(event);
    }

    private void emitVolumeButtonEvent(String action) {
        if(methodChannel == null)
            methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);

        if(methodChannel != null) {
            methodChannel.invokeMethod("onVolumeButtonEvent", Collections.singletonMap("action", action));
            Log.d(TAG, "Emitting volume button event: " + action);
        }
    }

    public Location getLastKnownLocation() {
        if (checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {

            Location gpsLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            if(gpsLocation != null) return gpsLocation;
            Location networkLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
            return networkLocation;
        } else {
            Log.d(TAG, "Location permission not granted. Cannot fetch location.");
            return null;
        }
    }

    public ArrayList<String> getPhoneNumbers() {
        ArrayList<String> phoneNums = new ArrayList<>();
        // Get the database path
        String databasePath = getApplicationContext().getDatabasePath("shahajjo.db").getAbsolutePath();
        // Open the database (make sure the mode is appropriate: read/write or readonly)
        SQLiteDatabase db = SQLiteDatabase.openDatabase(databasePath, null, SQLiteDatabase.OPEN_READWRITE);
        // Perform a query
        Cursor cursor = db.rawQuery("SELECT * FROM sos_contacts", null);
        // Iterate through the results
        if (cursor.moveToFirst()) {
            do {
                String phoneNumber = cursor.getString(cursor.getColumnIndex("phoneNumber"));
                int smsEnabled = cursor.getInt(cursor.getColumnIndex("smsEnabled"));
                if (smsEnabled == 1) phoneNums.add(phoneNumber);
            } while (cursor.moveToNext());
        }
    
        // Close the cursor and database
        cursor.close();
        db.close();

        return phoneNums;
    }

    public void sendSmsToSosContacts() {
        // get data from shared preferences
        SharedPreferences sharedPreferences = getSharedPreferences("shahajjo", MODE_PRIVATE);
        String username = sharedPreferences.getString("username", "");
        String phoneNum = sharedPreferences.getString("phoneNumber", "");

        Log.d(TAG, "Username: " + username + ", Phone Number: " + phoneNum);

        // Get sos contacts from sqlite db
        ArrayList<String> phoneNumbers = getPhoneNumbers();
        Location location = getLastKnownLocation();
        
        // Send SMS to sos contacts
        String locationUrl = (location != null) 
            ? "https://maps.google.com/?q=" + location.getLatitude() + "," + location.getLongitude()
            : "Location not available";

        String sms = "SOS Alert!\n" + 
                    "User Name: " + username + "\n" + 
                    "Phone Number: " + phoneNum + "\n" + 
                    "Location: " + locationUrl;
        Log.d(TAG, sms);
        smsService.sendSmsToMultipleNumbers(phoneNumbers.toArray(new String[0]), sms);
        // Trigger vibration
        Vibrator vibrator = (Vibrator) getSystemService(VIBRATOR_SERVICE);
        if (vibrator != null && vibrator.hasVibrator()) {
            vibrator.vibrate(2000); // Vibrates for 5 seconds
        }
        
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }
}

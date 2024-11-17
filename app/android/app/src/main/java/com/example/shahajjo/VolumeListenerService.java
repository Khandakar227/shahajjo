package com.example.shahajjo;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.IBinder;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;


public class VolumeListenerService extends Service {
    private static final String CHANNEL_ID = "VolumeServiceChannel";
    private static final int NOTIFICATION_ID = 1;
    private VolumeButtonReceiver volumeButtonReceiver;
    private boolean isServiceRunning = false;

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!isServiceRunning) {
            startForeground(NOTIFICATION_ID, createNotification());
            registerVolumeReceiver();
            isServiceRunning = true;
        }
        // If service gets killed, restart it
        return START_STICKY;
    }

    private void registerVolumeReceiver() {
        if (volumeButtonReceiver == null) {
            volumeButtonReceiver = new VolumeButtonReceiver();
            IntentFilter filter = new IntentFilter();
            filter.addAction("android.intent.action.MEDIA_BUTTON"); // Listen for media button events
            registerReceiver(volumeButtonReceiver, filter);
        }
    }
    

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                CHANNEL_ID,
                "Volume Listener Service",
                NotificationManager.IMPORTANCE_LOW
            );
            serviceChannel.setShowBadge(false);
            serviceChannel.setSound(null, null);
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(serviceChannel);
            }
        }
    }

    private Notification createNotification() {
        return new NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Volume Listener")
            .setContentText("Monitoring volume buttons")
            // .setSmallIcon(R.drawable.ic_notification)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setSound(null)
            .build();
    }

    @Override
    public void onDestroy() {
        if (volumeButtonReceiver != null) {
            unregisterReceiver(volumeButtonReceiver);
            volumeButtonReceiver = null;
        }
        isServiceRunning = false;
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
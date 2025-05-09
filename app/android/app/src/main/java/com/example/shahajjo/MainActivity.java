package com.example.shahajjo;

import android.content.Intent;
import android.provider.Settings;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.view.accessibility.AccessibilityManager;
import android.accessibilityservice.AccessibilityService;
import io.flutter.embedding.engine.FlutterEngineCache;
import android.content.SharedPreferences;

import java.util.List;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_NAME = "com.example.shahajjo/accessibility";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        FlutterEngineCache.getInstance().put("1", flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("isAccessibilityServiceEnabled")) {
                        boolean isEnabled = isAccessibilityServiceEnabled(this, VolumeAccessibilityService.class);
                        result.success(isEnabled);
                    } else if (call.method.equals("openAccessibilitySettings")) {
                        openAccessibilitySettings();
                        result.success(null);
                    } else if (call.method.equals("upateSharedPref")) {
                        String key = call.argument("key");
                        String value = call.argument("value");
                        getSharedPreferences("shahajjo", MODE_PRIVATE).edit().putString(key, value).apply();
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void openAccessibilitySettings() {
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    private boolean isAccessibilityServiceEnabled(Context context, Class<? extends AccessibilityService> serviceClass) {
        AccessibilityManager accessibilityManager =
            (AccessibilityManager) context.getSystemService(Context.ACCESSIBILITY_SERVICE);
        List<AccessibilityServiceInfo> enabledServices =
            accessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK);

        for (AccessibilityServiceInfo enabledService : enabledServices) {
            if (enabledService.getId().contains(context.getPackageName()) &&
                enabledService.getId().contains(serviceClass.getSimpleName())) {
                return true;
            }
        }
        return false;
    }
}
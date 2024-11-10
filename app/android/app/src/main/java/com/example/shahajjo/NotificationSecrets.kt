package com.example.shahajjo

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context

class NotificationSecrets(private val context: Context) {
    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getNotificationPrivateKeyId" -> result.success(context.getString(R.string.notification_private_key_id))
            "getNotificationPrivateKey" -> result.success(context.getString(R.string.notification_private_key))
            else -> result.notImplemented()
        }
    }
}
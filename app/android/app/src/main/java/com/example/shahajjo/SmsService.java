package com.example.shahajjo;
import android.telephony.SmsManager;
import android.util.Log;

public class SmsService {
    SmsManager smsManager = SmsManager.getDefault();
    public void sendSmsToMultipleNumbers(String[] phoneNumbers, String message) {
        for (String number : phoneNumbers) {
            try {
                smsManager.sendTextMessage(number, null, message, null, null);
                Log.d("SMS", "SMS sent to: " + number);
            } catch (Exception e) {
                Log.e("SMS", "Failed to send SMS to: " + number, e);
            }
        }
    }
}

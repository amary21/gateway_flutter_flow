package com.example.existing_flutter_app

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustDeeplink

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent: Intent = intent
        val data = intent.data
        Adjust.processDeeplink(AdjustDeeplink(data), this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val data = intent?.data
        Adjust.processDeeplink(AdjustDeeplink(data), this)
    }
}

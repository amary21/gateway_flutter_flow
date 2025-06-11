package com.example.existing_flutter_app

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import android.content.Context
import android.util.Log
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustDeeplink
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.existing_flutter_app/intent_data"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intentData = getIntent()
        val data = intentData.data
        Adjust.processDeeplink(AdjustDeeplink(data), context as Context)

        // Send intent data to Flutter
        sendIntentDataToFlutter(data?.toString())
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val data = intent.data
        Adjust.processDeeplink(AdjustDeeplink(data), context as Context)

        // Send intent data to Flutter
        sendIntentDataToFlutter(data?.toString())
    }

    private fun sendIntentDataToFlutter(data: String?) {
        Log.e("sendIntentDataToFlutter", data.toString())
        methodChannel?.invokeMethod("intentDataReceived", mapOf("url" to data))
    }
}

package com.example.pix_hunt_project

import android.content.Intent  // Add this import
import android.net.Uri
import androidx.core.content.FileProvider  // Add this import
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File  // Add this import

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.pixhunt/gallery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val path = call.argument<String>("path") ?: return@setMethodCallHandler
                    val file = File(path)
                    val uri = FileProvider.getUriForFile(
                        this,
                        "${packageName}.provider",
                        file
                    )
                    sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri))
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
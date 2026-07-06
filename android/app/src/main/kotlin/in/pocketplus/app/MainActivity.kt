package `in`.pocketplus.app

import android.database.Cursor
import android.net.Uri
import android.provider.Telephony
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth so
// the biometric prompt can attach to a FragmentActivity host.
class MainActivity: FlutterFragmentActivity() {
    companion object {
        var channel: MethodChannel? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pocketplus/sms")
        // Share channel with SmsReceiver for fallback
        SmsReceiver.setChannel(channel)
        
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "scanInbox" -> {
                    try {
                        val messages = scanSmsInbox()
                        result.success(messages)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "scanInbox failed: ${e.message}")
                        result.error("SCAN_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scanSmsInbox(): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        
        try {
            val uri = Telephony.Sms.CONTENT_URI
            val projection = arrayOf(
                Telephony.Sms.ADDRESS,
                Telephony.Sms.BODY,
                Telephony.Sms.DATE
            )
            val sortOrder = "${Telephony.Sms.DATE} DESC"

            // Scan at least the last ~2 months of SMS so historical transactions
            // going that far back are captured. The previous flat 50-message cap
            // bounded the scan by message *count*, which collapsed to roughly a
            // week for high-volume inboxes. Telephony.Sms.DATE is in epoch millis.
            val twoMonthsMillis = 62L * 24 * 60 * 60 * 1000
            val cutoffMillis = System.currentTimeMillis() - twoMonthsMillis
            val selection = "${Telephony.Sms.DATE} >= ?"
            val selectionArgs = arrayOf(cutoffMillis.toString())

            val cursor: Cursor? = contentResolver.query(
                uri,
                projection,
                selection,
                selectionArgs,
                sortOrder
            )

            cursor?.use { c ->
                // The date window above is the primary bound; this is just a
                // safety cap so an extremely busy inbox can't dispatch an
                // unbounded number of messages for parsing.
                val maxCount = minOf(c.count, 500)
                var count = 0
                while (c.moveToNext() && count < maxCount) {
                    val address = c.getString(c.getColumnIndexOrThrow(Telephony.Sms.ADDRESS)) ?: ""
                    val body = c.getString(c.getColumnIndexOrThrow(Telephony.Sms.BODY)) ?: ""
                    val dateMillis = c.getLong(c.getColumnIndexOrThrow(Telephony.Sms.DATE))

                    if (body.isNotEmpty() && address.isNotEmpty()) {
                        messages.add(mapOf(
                            "text" to body,
                            "senderId" to address,
                            "timestamp" to dateMillis
                        ))
                    }
                    count++
                }
            }
            
            Log.d("MainActivity", "Scanned ${messages.size} SMS from inbox")
        } catch (e: Exception) {
            Log.e("MainActivity", "Error scanning SMS inbox: ${e.message}")
        }
        
        return messages
    }

    override fun onDestroy() {
        channel?.setMethodCallHandler(null)
        channel = null
        super.onDestroy()
    }
}

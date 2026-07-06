package `in`.pocketplus.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log
import io.flutter.plugin.common.MethodChannel

class SmsReceiver : BroadcastReceiver() {
    companion object {
        private var staticChannel: MethodChannel? = null
        private val pendingMessages = mutableListOf<Triple<String, String, Long>>()

        @Synchronized
        fun setChannel(channel: MethodChannel?) {
            staticChannel = channel
            if (channel != null && pendingMessages.isNotEmpty()) {
                Log.d("SmsReceiver", "Flushing ${pendingMessages.size} buffered SMS to Flutter")
                val messagesToFlush = pendingMessages.toList()
                pendingMessages.clear()
                for ((text, senderId, timestamp) in messagesToFlush) {
                    sendToFlutter(channel, text, senderId, timestamp)
                }
            }
        }

        fun getChannel(): MethodChannel? = staticChannel

        private fun sendToFlutter(channel: MethodChannel, text: String, senderId: String, timestampMillis: Long) {
            try {
                val data = mapOf("text" to text, "senderId" to senderId, "timestamp" to timestampMillis)
                channel.invokeMethod("onSmsReceived", data)
                Log.d("SmsReceiver", "SMS forwarded to Flutter via channel")
            } catch (e: Exception) {
                Log.e("SmsReceiver", "Failed to invoke Flutter channel: ${e.message}")
            }
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent == null || intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            return
        }

        try {
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            if (messages != null && messages.isNotEmpty()) {
                val fullBody = StringBuilder()
                var senderId: String? = null
                var timestampMillis = 0L
                for (msg in messages) {
                    if (msg != null) {
                        if (senderId == null) {
                            senderId = msg.displayOriginatingAddress ?: msg.originatingAddress
                            timestampMillis = msg.timestampMillis
                        }
                        fullBody.append(msg.messageBody)
                    }
                }
                if (timestampMillis <= 0L) timestampMillis = System.currentTimeMillis()

                val text = fullBody.toString()
                if (text.isNotEmpty() && senderId != null) {
                    Log.d("SmsReceiver", "Incoming SMS from $senderId: $text")

                    val channel = staticChannel ?: MainActivity.channel
                    if (channel != null) {
                        sendToFlutter(channel, text, senderId, timestampMillis)
                    } else {
                        Log.d("SmsReceiver", "MethodChannel not ready yet, buffering SMS")
                        synchronized(pendingMessages) {
                            pendingMessages.add(Triple(text, senderId, timestampMillis))
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("SmsReceiver", "Error processing SMS: ${e.message}")
        }
    }
}

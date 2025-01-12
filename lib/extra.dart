// package com.hokki.team_husky
// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.content.IntentFilter
// import android.os.Bundle
// import android.os.Handler
// import android.util.Log
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.EventChannel
// import java.util.*
// import android.telephony.SmsMessage
//
// class MainActivity : FlutterActivity(), SmsListener {
// private val CHANNEL_NAME = "com.hokki.team_husky.SMS_RECEIVED"
// private var eventSink: EventChannel.EventSink? = null
//
// override fun onCreate(savedInstanceState: Bundle?) {
// super.onCreate(savedInstanceState)
//
// // SmsReceiver 인스턴스 생성 및 등록
// val smsReceiver = SmsReceiver(this)
// val filter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
// registerReceiver(smsReceiver, filter)
// }
//
// override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
// super.configureFlutterEngine(flutterEngine)
//
// EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setStreamHandler(
// object : EventChannel.StreamHandler {
// override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
// // 이벤트 수신을 시작할 때 필요한 작업을 수행합니다.
// eventSink = events
// }
//
// override fun onCancel(arguments: Any?) {
// // 이벤트 수신을 중지할 때 필요한 작업을 수행합니다.
// eventSink = null
// }
// }
// )
// }
//
// override fun onSmsReceived(sender: String?, message: String?) {
// // 받은 메시지를 Flutter로 전송
// val smsData = "$sender:$message"
// eventSink?.success(smsData)
// }
// }
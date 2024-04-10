package com.hokki.team_husky

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.telephony.SmsMessage
import android.util.Log

interface SmsListener {
    fun onSmsReceived(sender: String?, message: String?)
}
class SmsReceiver(private val smsListener: SmsListener) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.provider.Telephony.SMS_RECEIVED") {
            val bundle = intent.extras
            if (bundle != null) {
                val pdus = bundle.get("pdus") as Array<Any>?
                if (pdus != null) {

                    for (pdu in pdus) {
                        val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray)
                        val messageBody = smsMessage.messageBody
                        val sender = smsMessage.originatingAddress
                        // SMS 데이터 로그에 찍기
                        Log.d("SmsReceiver", "messageBody 내용: ${messageBody.replace("\n", " ")}")

                        smsListener.onSmsReceived(sender, messageBody.replace("\n", " "))



                    }
                }
            }
        }
    }
}
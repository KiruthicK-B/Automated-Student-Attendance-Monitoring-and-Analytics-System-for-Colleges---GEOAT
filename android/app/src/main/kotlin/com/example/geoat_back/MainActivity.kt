package com.example.flutterprojects

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import com.google.firebase.FirebaseApp

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Firebase (if absolutely necessary in native code)
        FirebaseApp.initializeApp(this)
    }
}

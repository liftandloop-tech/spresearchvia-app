# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Dio
-keep class com.squareup.okhttp3.** { *; }
-keep interface com.squareup.okhttp3.** { *; }
-dontwarn com.squareup.okhttp3.**

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Razorpay
-keep class com.razorpay.** { *; }
-keep class org.json.** { *; }
-dontwarn com.razorpay.**
-dontwarn org.json.**

# Google Play Core
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ProGuard annotations
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

# SharedPreferences
-keep class android.content.SharedPreferences { *; }
-keep class * extends android.content.SharedPreferences$Editor { *; }

# Secure Storage
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**

# File Picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# Connectivity Plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }
-dontwarn dev.fluttercommunity.plus.connectivity.**

# Package Info Plus
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }
-dontwarn dev.fluttercommunity.plus.packageinfo.**

# Device Info Plus
-keep class dev.fluttercommunity.plus.device_info.** { *; }
-dontwarn dev.fluttercommunity.plus.device_info.**

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }
-dontwarn io.flutter.plugins.urllauncher.**

# WebView Flutter
-keep class io.flutter.plugins.webviewflutter.** { *; }
-dontwarn io.flutter.plugins.webviewflutter.**

# Path Provider
-keep class io.flutter.plugins.pathprovider.** { *; }
-dontwarn io.flutter.plugins.pathprovider.**

# Flutter Toast
-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }
-dontwarn io.github.ponnamkarthik.toast.fluttertoast.**

# SQFlite
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**
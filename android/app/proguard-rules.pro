# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/username/Library/Android/sdk/tools/proguard/proguard-android.txt

## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }

## Razorpay
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/short
-keep class com.razorpay.CheckoutActivity {*;}
-keep class com.razorpay.PaymentResultListener {*;}
-keep class com.razorpay.PaymentData {*;}
-keep class com.razorpay.CheckoutPresenter {*;}
-keep class com.razorpay.BasePresenter {*;}

## OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

## Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

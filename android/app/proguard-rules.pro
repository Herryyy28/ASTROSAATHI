# Razorpay ProGuard / R8 Rules
-keep class com.razorpay.** {*;}
-dontwarn com.razorpay.**
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes *Annotation*
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void onPageFinished(android.webkit.WebView, java.lang.String);
    public void onReceivedError(android.webkit.WebView, int, java.lang.String, java.lang.String);
}

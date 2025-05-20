# Keep TensorFlow Lite GPU delegate classes
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.** { *; }

# General TensorFlow Lite rules
-keepclassmembers class org.tensorflow.lite.** {
  *;
}

# Also keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Don't warn about missing classes
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn org.tensorflow.lite.**
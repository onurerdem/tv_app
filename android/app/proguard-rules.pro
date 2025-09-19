-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }

-keep class com.google.firebase.** { *; }
-keep class org.json.** { *; }

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keepnames class com.google.android.gms.common.api.internal.TaskApiCall { *; }
-keep class com.google.android.gms.common.internal.safeparcel.** { *; }

-keep class com.google.firebase.auth.** { *; }
-keepnames class com.google.firebase.auth.api.internal.GetAccountInfoResponse { *; }
-keepnames class com.google.firebase.auth.api.internal.CreateAuthUriResponse { *; }
-keepnames class com.google.firebase.auth.api.internal.SetAccountInfoResponse { *; }

-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses

-keepnames class com.onurerdem.tv_app.** { *; }
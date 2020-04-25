package com.mp.amapnaviplugin;

import android.app.Activity;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AmapnavipluginPlugin */
public class AmapnavipluginPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

  private MethodChannel methodChannel;
  private Activity mActivity;
  private FlutterPluginBinding mFlutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), Constant.NAVI_CHANNEL_NAME);
    methodChannel.setMethodCallHandler(this);

    mFlutterPluginBinding = flutterPluginBinding;
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), Constant.NAVI_CHANNEL_NAME);
    channel.setMethodCallHandler(new AmapnavipluginPlugin());

    registrar.platformViewRegistry().registerViewFactory(
            Constant.NAVI_CHANNEL_NAME + "/AMapNaviView", new AMapNaviPluginFactory(
                    registrar.messenger(), registrar.activity())
    );
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (methodChannel != null) {
      methodChannel.setMethodCallHandler(null);
      methodChannel = null;
    }
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    mActivity = activityPluginBinding.getActivity();

    mFlutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
            Constant.NAVI_CHANNEL_NAME + "/AMapNaviView", new AMapNaviPluginFactory(
                    mFlutterPluginBinding.getBinaryMessenger(), mActivity)
    );
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}

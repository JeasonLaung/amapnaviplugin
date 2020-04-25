package com.mp.amapnaviplugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class AMapNaviPluginFactory extends PlatformViewFactory {
    private static final String TAG = "AMapNaviPluginFactory";

    //    private final AtomicInteger mActivityState;
    private final BinaryMessenger mBinaryMessenger;
    private final Activity mActivity;

    public AMapNaviPluginFactory(
//            AtomicInteger activityState,
            BinaryMessenger binaryMessenger, Activity activity) {
        super(StandardMessageCodec.INSTANCE);

//        mActivityState = activityState;
        mBinaryMessenger = binaryMessenger;
        mActivity = activity;
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {

        Gson gson = new Gson();
        AMapNaviModel aMapNaviModel = new AMapNaviModel();
        if (o instanceof String) {
            Log.d(TAG, "create: "+o.toString());
            aMapNaviModel = gson.fromJson(o.toString(), AMapNaviModel.class);
        }

        AMapNaviPluginView aMapNaviPluginView = new AMapNaviPluginView(
//                context,
//                mActivityState,
                mBinaryMessenger, mActivity, i, aMapNaviModel);

        return aMapNaviPluginView;
    }
}

package com.mp.amapnaviplugin;

import android.app.Activity;
import android.app.Application;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.amap.api.maps.AMap;
import com.amap.api.navi.AMapNavi;
import com.amap.api.navi.AMapNaviListener;
import com.amap.api.navi.AMapNaviView;
import com.amap.api.navi.AMapNaviViewListener;
import com.amap.api.navi.AMapNaviViewOptions;
import com.amap.api.navi.enums.AMapNaviViewShowMode;
import com.amap.api.navi.enums.NaviType;
import com.amap.api.navi.model.AMapCalcRouteResult;
import com.amap.api.navi.model.AMapLaneInfo;
import com.amap.api.navi.model.AMapModelCross;
import com.amap.api.navi.model.AMapNaviCameraInfo;
import com.amap.api.navi.model.AMapNaviCross;
import com.amap.api.navi.model.AMapNaviInfo;
import com.amap.api.navi.model.AMapNaviLocation;
import com.amap.api.navi.model.AMapNaviRouteNotifyData;
import com.amap.api.navi.model.AMapNaviTrafficFacilityInfo;
import com.amap.api.navi.model.AMapServiceAreaInfo;
import com.amap.api.navi.model.AimLessModeCongestionInfo;
import com.amap.api.navi.model.AimLessModeStat;
import com.amap.api.navi.model.NaviInfo;
import com.amap.api.navi.model.NaviLatLng;
import com.autonavi.tbt.TrafficFacilityInfo;
import com.google.gson.Gson;
import com.mp.amapnaviplugin.model.LatLng;
import com.mp.amapnaviplugin.model.MNaviInfo;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class AMapNaviPluginView implements PlatformView, MethodChannel.MethodCallHandler,
        Application.ActivityLifecycleCallbacks, AMapNaviListener, AMapNaviViewListener, AMap.OnMapTouchListener {
    private static final String TAG = "AMapNaviPluginView";

    //    private final Context mContext;
//    private final AtomicInteger mAtomicInteger;
    //private final PluginRegistry.Registrar mRegistrar;
    private final BinaryMessenger mBinaryMessenger;
    private final Activity mActivity;
    private final AMapNaviModel mAMapNaviModel;

    private MethodChannel mNaviChannel;

    private AMapNaviView mAMapNaviView;//导航视图类
    private AMapNavi mAMapNavi;//导航控制类

    private LatLng mStartLatLon;//开始点
    private LatLng mEndLatLon;//结束点

    private boolean disposed = false;

    public AMapNaviPluginView(
//            Context context,
            BinaryMessenger binaryMessenger,
            Activity activity,
            int id,
            AMapNaviModel aMapNaviModel) {
//        mContext = context;
//        mAtomicInteger = atomicInteger;
        mBinaryMessenger = binaryMessenger;
        mActivity = activity;
        mAMapNaviModel = aMapNaviModel;

        mStartLatLon = aMapNaviModel.getStartLatLng();
        mEndLatLon = aMapNaviModel.getEndLatLng();

        mNaviChannel = new MethodChannel(binaryMessenger, Constant.NAVI_CHANNEL_NAME + "/" + id);
        mNaviChannel.setMethodCallHandler(this);

        //先试试这样创建对象
        //flutter传过来的配置options
        AMapNaviViewOptions options = initializeOptions();
        mAMapNaviView = new AMapNaviView(mActivity, options);
        mAMapNaviView.setNaviMode(mAMapNaviModel.getNaviMode());

        mAMapNaviView.onCreate(null);

        mAMapNaviView.setAMapNaviViewListener(this);

        mAMapNaviView.getMap();

        mAMapNavi = AMapNavi.getInstance(mActivity.getApplicationContext());

        mAMapNavi.addAMapNaviListener(this);

        mAMapNavi.setUseInnerVoice(true);//默认开启内置语音

        activity.getApplication().registerActivityLifecycleCallbacks(this);
    }

    private AMapNaviViewOptions initializeOptions() {
        AMapNaviViewOptions options = new AMapNaviViewOptions();
        options.setAfterRouteAutoGray(true);

        if (this.mAMapNaviModel != null) {
            options.setPointToCenter(0.5,0.7);
            options.setLayoutVisible(mAMapNaviModel.isSetLayoutVisible());//隐藏高德自带的UI元素
            options.setScreenAlwaysBright(mAMapNaviModel.isSetScreenAlwaysBright());//开启常亮
            options.setAfterRouteAutoGray(mAMapNaviModel.isSetAfterRouteAutoGray());//走过的路程置灰
            options.setAutoLockCar(mAMapNaviModel.isSetAutoLockCar());
            options.setCameraBubbleShow(mAMapNaviModel.isSetCameraBubbleShow());
            options.setRealCrossDisplayShow(mAMapNaviModel.isSetRealCrossDisplayShow());
            options.setModeCrossDisplayShow(mAMapNaviModel.isSetModeCrossDisplayShow());
            options.setTrafficInfoUpdateEnabled(mAMapNaviModel.isSetTrafficInfoUpdateEnabled());//开启交通播报
            options.setTrafficLine(mAMapNaviModel.isSetTrafficLine());
            options.setTrafficLayerEnabled(mAMapNaviModel.isShowTrafficButton());//实时交通按钮
            options.setTrafficBarEnabled(mAMapNaviModel.isShowTrafficBar());//显示路况光柱
            options.setRouteListButtonShow(mAMapNaviModel.isShowBrowseRouteButton());//显示全览按钮
            options.setSettingMenuEnabled(mAMapNaviModel.isShowMoreButton());//显示菜单按钮
        }

        return options;
    }

//    public void setup() {
//        switch (mAtomicInteger.get()) {
//            case Constant.CREATED:
//                if (mAMapNaviView != null) {
//                    mAMapNaviView.onCreate(null);
//                }
//                break;
//            case Constant.RESUMED:
//                //mAMapNaviView.onCreate(null);
//                if (mAMapNaviView != null) {
//                    mAMapNaviView.onResume();
//                }
//                break;
//            case Constant.PAUSED:
//                if (mAMapNaviView != null) {
//                    mAMapNaviView.onPause();
//                }
//                break;
//            case Constant.DESTROYED:
//                if (mAMapNaviView != null) {
//                    mAMapNaviView.setAMapNaviViewListener(null);
//                    mAMapNaviView.onDestroy();
//                    mAMapNavi.removeAMapNaviListener(this);
//                }
//                if (mAMapNavi != null) {
//                    mAMapNavi.stopNavi();
//                    mAMapNavi.destroy();
//                }
//                break;
//
//        }
//    }

    @Override
    public View getView() {
        return mAMapNaviView;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        if (mAMapNaviView != null) {
            mAMapNaviView.setAMapNaviViewListener(null);
            mAMapNaviView.onDestroy();
        }
        if (mAMapNavi != null) {
            mAMapNavi.removeAMapNaviListener(this);
            mAMapNavi.stopNavi();
            mAMapNavi.destroy();
        }
        if (mNaviChannel != null) {
            mNaviChannel.setMethodCallHandler(null);
        }
        if (mActivity != null) {
            mActivity.getApplication().unregisterActivityLifecycleCallbacks(this);
        }
    }

    ///////////////////////////// methodCall 方法体 /////////////////////////


    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        //开始导航
        if (methodCall.method.equals("startNavi")) {
//            if (methodCall.arguments instanceof String) {

            try {
                Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "startNavi");

                //路线规划成功 开始导航
                mAMapNavi.startNavi(NaviType.EMULATOR);

            } catch (Throwable throwable) {
                throwable.printStackTrace();
                result.error(throwable.getMessage(), null, null);
                return;
            }
            result.success("success");
//            }
        }

        //恢复锁车状态:用于用户主动恢复之前的导航锁车状态（比如从全览画面，挪动地图后画面返回）
        if (methodCall.method.equals("recoverLockMode")) {
            try {
                Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "recoverLockMode");

                //锁车
                mAMapNaviView.setShowMode(AMapNaviViewShowMode.SHOW_MODE_LOCK_CAR);
            } catch (Throwable throwable) {
                throwable.printStackTrace();
                result.error(throwable.getMessage(), null, null);
                return;
            }
            result.success("success");
        }

        //全览模式  展示全览：成功算路获得路径之后，可将地图缩放到完全展示该路径
        if (methodCall.method.equals("displayOverview")) {
            try {
                Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "displayOverview");

                //全览地图
                mAMapNaviView.setShowMode(AMapNaviViewShowMode.SHOW_MODE_DISPLAY_OVERVIEW);
            } catch (Throwable throwable) {
                throwable.printStackTrace();
                result.error(throwable.getMessage(), null, null);
                return;
            }
            result.success("success");
        }

    }

    ///////////////////////////// methodCall 方法体 /////////////////////////


    /////////////////////////////Application.ActivityLifecycleCallbacks 回调 /////////////////////////


    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
        if (mAMapNaviView != null) {
            mAMapNaviView.onCreate(bundle);
        }
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
        if (mAMapNaviView != null) {
            mAMapNaviView.onResume();
        }
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
        if (mAMapNaviView != null) {
            mAMapNaviView.onPause();
        }
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
        if (mAMapNaviView != null) {
            mAMapNaviView.onSaveInstanceState(bundle);
        }
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (disposed || activity.hashCode() != mActivity.hashCode()) {
            return;
        }
        if (mAMapNaviView != null) {
            mAMapNaviView.onDestroy();
        }
    }

    /////////////////////////////Application.ActivityLifecycleCallbacks 回调 /////////////////////////


    /////////////////////////////AMapNaviListener 回调 /////////////////////////

    @Override
    public void onInitNaviFailure() {
        Log.d(TAG, "onInitNaviFailure: ");
    }

    @Override
    public void onInitNaviSuccess() {
        /**
         * 方法:
         *   int strategy=mAMapNavi.strategyConvert(congestion, avoidhightspeed, cost, hightspeed, multipleroute);
         * 参数:
         * @congestion 躲避拥堵
         * @avoidhightspeed 不走高速
         * @cost 避免收费
         * @hightspeed 高速优先
         * @multipleroute 多路径
         *
         * 说明:
         *      以上参数都是boolean类型，其中multipleroute参数表示是否多条路线，如果为true则此策略会算出多条路线。
         * 注意:
         *      不走高速与高速优先不能同时为true
         *      高速优先与避免收费不能同时为true
         */

        Log.d(TAG, "onInitNaviSuccess: start");

        int strategy = 0;
        try {
            strategy = mAMapNavi.strategyConvert(true, false, false, false, false);

            final List<NaviLatLng> sList = new ArrayList<>();
            NaviLatLng startNaviLatLng = new NaviLatLng(mStartLatLon.getLatitude(), mStartLatLon.getLongitude());
            sList.add(startNaviLatLng);

            final List<NaviLatLng> eList = new ArrayList<>();
            NaviLatLng endNaviLatLng = new NaviLatLng(mEndLatLon.getLatitude(), mEndLatLon.getLongitude());
            eList.add(endNaviLatLng);
            mAMapNavi.calculateDriveRoute(sList,eList, null, strategy);//起点为null，途经点为null
        } catch (Exception e) {
            e.printStackTrace();
        }

        // mAMapNavi.calculateWalkRoute(new NaviLatLng(39.92, 116.43), new NaviLatLng(39.92, 116.53));

        Log.d(TAG, "onInitNaviSuccess: end");
    }

    @Override
    public void onStartNavi(int i) {

    }

    @Override
    public void onTrafficStatusUpdate() {

    }

    @Override
    public void onLocationChange(AMapNaviLocation aMapNaviLocation) {

    }

    @Override
    public void onGetNavigationText(int i, String s) {

    }

    @Override
    public void onGetNavigationText(String s) {

    }

    @Override
    public void onEndEmulatorNavi() {

    }

    @Override
    public void onArriveDestination() {

    }

    @Override
    public void onCalculateRouteFailure(int i) {

    }

    @Override
    public void onReCalculateRouteForYaw() {

    }

    @Override
    public void onReCalculateRouteForTrafficJam() {

    }

    @Override
    public void onArrivedWayPoint(int i) {

    }

    @Override
    public void onGpsOpenStatus(boolean b) {

    }

    @Override
    public void onNaviInfoUpdate(NaviInfo naviInfo) {
//        if (naviInfo == null) {
//            return;
//        }
//
//        MNaviInfo mNaviInfo = new MNaviInfo();
//        mNaviInfo.setCurStepRetainDistance(naviInfo.getCurStepRetainDistance());
//        mNaviInfo.setNextRoadName(naviInfo.getNextRoadName());
//        mNaviInfo.setPathRetainDistance(naviInfo.getPathRetainDistance());
//        mNaviInfo.setPathRetainTime(naviInfo.getPathRetainTime());
//
//        //bitmap图片做下处理
//        if (naviInfo.getIconBitmap() != null) {
//
//
//            Bitmap iconBitmap = naviInfo.getIconBitmap();
//
//            //这个方法数据会卡 一秒一卡
////            int bytes = iconBitmap.getByteCount();
////            ByteBuffer buffer = ByteBuffer.allocate(bytes);
////            iconBitmap.copyPixelsToBuffer(buffer);
////            byte[] data = buffer.array();
//
//            ByteArrayOutputStream baos = new ByteArrayOutputStream();
//            boolean isSuccess = iconBitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);
//            mNaviInfo.setIconBitmap(isSuccess ? baos.toByteArray() : null);
//
//            //释放bitmap内存
////            if (!iconBitmap.isRecycled()) {
////                iconBitmap.recycle();
////                iconBitmap = null;
////            }
//
//        } else {
//            mNaviInfo.setIconBitmap(null);
//        }
//
//        mNaviChannel.invokeMethod("onNaviInfoUpdate", new Gson().toJson(mNaviInfo));
//        Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "onNaviInfoUpdate");
    }

    @Override
    public void onNaviInfoUpdated(AMapNaviInfo aMapNaviInfo) {

    }


    @Override
    public void updateCameraInfo(AMapNaviCameraInfo[] aMapNaviCameraInfos) {

    }

    @Override
    public void updateIntervalCameraInfo(AMapNaviCameraInfo aMapNaviCameraInfo, AMapNaviCameraInfo aMapNaviCameraInfo1, int i) {

    }

    @Override
    public void onServiceAreaUpdate(AMapServiceAreaInfo[] aMapServiceAreaInfos) {

    }

    @Override
    public void showCross(AMapNaviCross aMapNaviCross) {

    }

    @Override
    public void hideCross() {

    }

    @Override
    public void showModeCross(AMapModelCross aMapModelCross) {

    }

    @Override
    public void hideModeCross() {

    }

    @Override
    public void showLaneInfo(AMapLaneInfo[] aMapLaneInfos, byte[] bytes, byte[] bytes1) {

    }

    @Override
    public void showLaneInfo(AMapLaneInfo aMapLaneInfo) {

    }

    @Override
    public void hideLaneInfo() {

    }

    @Override
    public void onCalculateRouteSuccess(int[] ints) {

    }

    @Override
    public void notifyParallelRoad(int i) {

    }

    @Override
    public void OnUpdateTrafficFacility(AMapNaviTrafficFacilityInfo[] aMapNaviTrafficFacilityInfos) {

    }

    @Override
    public void OnUpdateTrafficFacility(AMapNaviTrafficFacilityInfo aMapNaviTrafficFacilityInfo) {

    }

    @Override
    public void OnUpdateTrafficFacility(TrafficFacilityInfo trafficFacilityInfo) {

    }

    @Override
    public void updateAimlessModeStatistics(AimLessModeStat aimLessModeStat) {

    }

    @Override
    public void updateAimlessModeCongestionInfo(AimLessModeCongestionInfo aimLessModeCongestionInfo) {

    }

    @Override
    public void onPlayRing(int i) {

    }

    @Override
    public void onCalculateRouteSuccess(AMapCalcRouteResult aMapCalcRouteResult) {
        Log.d(TAG, "onCalculateRouteSuccess: start");

        mNaviChannel.invokeMethod("onCalculateRouteSuccess", null);
        Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "onCalculateRouteSuccess");

        Log.d(TAG, "onCalculateRouteSuccess: end");
    }

    @Override
    public void onCalculateRouteFailure(AMapCalcRouteResult aMapCalcRouteResult) {
        Log.d(TAG, "onCalculateRouteFailure: " + aMapCalcRouteResult.getErrorDetail());
    }

    @Override
    public void onNaviRouteNotify(AMapNaviRouteNotifyData aMapNaviRouteNotifyData) {

    }

    /////////////////////////////AMapNaviListener 回调 /////////////////////////


    /////////////////////////////AMapNaviViewListener 回调 /////////////////////////

    @Override
    public void onNaviSetting() {
        mNaviChannel.invokeMethod("more_navi", null);
        Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "more_navi");

    }

    @Override
    public void onNaviCancel() {

    }

    @Override
    public boolean onNaviBackClick() {
        mNaviChannel.invokeMethod("close_navi", null);
        Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "close_navi");
        return true;
    }

    @Override
    public void onNaviMapMode(int i) {

    }

    @Override
    public void onNaviTurnClick() {

    }

    @Override
    public void onNextRoadClick() {

    }

    @Override
    public void onScanViewButtonClick() {

    }

    @Override
    public void onLockMap(boolean b) {

    }

    @Override
    public void onNaviViewLoaded() {

    }

    @Override
    public void onMapTypeChanged(int i) {

    }

    @Override
    public void onNaviViewShowMode(int i) {

    }

    /////////////////////////////AMapNaviViewListener 回调 /////////////////////////


    /////////////////////////////OnMapTouchListener 回调 /////////////////////////


    @Override
    public void onTouch(MotionEvent motionEvent) {
        mNaviChannel.invokeMethod("touchMap", null);
        Log.d(TAG, "android-->" + Constant.NAVI_CHANNEL_NAME + "::" + "touchMap");
    }


    /////////////////////////////OnMapTouchListener 回调 /////////////////////////

}

package com.mp.amapnaviplugin;

import android.os.Parcel;
import android.os.Parcelable;

import com.mp.amapnaviplugin.model.LatLng;

public class AMapNaviModel implements Parcelable {

    private LatLng startLatLng;

    //终点坐标
    private LatLng endLatLng;

    //    导航界面跟随模式，默认正北模式
    private int naviMode;

    //    是否显示界面元素，默认false
    private boolean setLayoutVisible;

    //      设置导航状态下屏幕是否一直开启
    private boolean setScreenAlwaysBright;

    //    走过的路线置灰
    private boolean setAfterRouteAutoGray;

    //    设置6秒后是否自动锁车
    private boolean setAutoLockCar;

    //    设置路线上的摄像头气泡是否显示
    private boolean setCameraBubbleShow;

    //    设置是否显示路口放大图(实景图)
    private boolean setRealCrossDisplayShow;

    //    设置是否显示路口放大图(路口模型图)
    private boolean setModeCrossDisplayShow;

    private boolean setTrafficInfoUpdateEnabled;

    //   是否绘制显示交通路况的线路
    private boolean setTrafficLine;

    //    是否显示实时交通按钮，默认true
    private boolean showTrafficButton;

    //    是否显示路况光柱，默认true
    private boolean showTrafficBar;

    //    是否显示全览按钮，默认true
    private boolean showBrowseRouteButton;

    //    是否显示更多按钮，默认true
    private boolean showMoreButton;

    //    是否使用导航组件，默认false
    private boolean isUseComponent;

    public AMapNaviModel() {
    }


    protected AMapNaviModel(Parcel in) {
        naviMode = in.readInt();
        setLayoutVisible = in.readByte() != 0;
        setScreenAlwaysBright = in.readByte() != 0;
        setAfterRouteAutoGray = in.readByte() != 0;
        setAutoLockCar = in.readByte() != 0;
        setCameraBubbleShow = in.readByte() != 0;
        setRealCrossDisplayShow = in.readByte() != 0;
        setModeCrossDisplayShow = in.readByte() != 0;
        setTrafficInfoUpdateEnabled = in.readByte() != 0;
        setTrafficLine = in.readByte() != 0;
        showTrafficButton = in.readByte() != 0;
        showTrafficBar = in.readByte() != 0;
        showBrowseRouteButton = in.readByte() != 0;
        showMoreButton = in.readByte() != 0;
        isUseComponent = in.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(naviMode);
        dest.writeByte((byte) (setLayoutVisible ? 1 : 0));
        dest.writeByte((byte) (setScreenAlwaysBright ? 1 : 0));
        dest.writeByte((byte) (setAfterRouteAutoGray ? 1 : 0));
        dest.writeByte((byte) (setAutoLockCar ? 1 : 0));
        dest.writeByte((byte) (setCameraBubbleShow ? 1 : 0));
        dest.writeByte((byte) (setRealCrossDisplayShow ? 1 : 0));
        dest.writeByte((byte) (setModeCrossDisplayShow ? 1 : 0));
        dest.writeByte((byte) (setTrafficInfoUpdateEnabled ? 1 : 0));
        dest.writeByte((byte) (setTrafficLine ? 1 : 0));
        dest.writeByte((byte) (showTrafficButton ? 1 : 0));
        dest.writeByte((byte) (showTrafficBar ? 1 : 0));
        dest.writeByte((byte) (showBrowseRouteButton ? 1 : 0));
        dest.writeByte((byte) (showMoreButton ? 1 : 0));
        dest.writeByte((byte) (isUseComponent ? 1 : 0));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<AMapNaviModel> CREATOR = new Creator<AMapNaviModel>() {
        @Override
        public AMapNaviModel createFromParcel(Parcel in) {
            return new AMapNaviModel(in);
        }

        @Override
        public AMapNaviModel[] newArray(int size) {
            return new AMapNaviModel[size];
        }
    };

    public LatLng getStartLatLng() {
        return startLatLng;
    }

    public void setStartLatLng(LatLng startLatLng) {
        this.startLatLng = startLatLng;
    }

    public LatLng getEndLatLng() {
        return endLatLng;
    }

    public void setEndLatLng(LatLng endLatLng) {
        this.endLatLng = endLatLng;
    }

    public int getNaviMode() {
        return naviMode;
    }

    public void setNaviMode(int naviMode) {
        this.naviMode = naviMode;
    }

    public boolean isSetLayoutVisible() {
        return setLayoutVisible;
    }

    public void setSetLayoutVisible(boolean setLayoutVisible) {
        this.setLayoutVisible = setLayoutVisible;
    }

    public boolean isSetScreenAlwaysBright() {
        return setScreenAlwaysBright;
    }

    public void setSetScreenAlwaysBright(boolean setScreenAlwaysBright) {
        this.setScreenAlwaysBright = setScreenAlwaysBright;
    }

    public boolean isSetAfterRouteAutoGray() {
        return setAfterRouteAutoGray;
    }

    public void setSetAfterRouteAutoGray(boolean setAfterRouteAutoGray) {
        this.setAfterRouteAutoGray = setAfterRouteAutoGray;
    }

    public boolean isSetAutoLockCar() {
        return setAutoLockCar;
    }

    public void setSetAutoLockCar(boolean setAutoLockCar) {
        this.setAutoLockCar = setAutoLockCar;
    }

    public boolean isSetCameraBubbleShow() {
        return setCameraBubbleShow;
    }

    public void setSetCameraBubbleShow(boolean setCameraBubbleShow) {
        this.setCameraBubbleShow = setCameraBubbleShow;
    }

    public boolean isSetRealCrossDisplayShow() {
        return setRealCrossDisplayShow;
    }

    public void setSetRealCrossDisplayShow(boolean setRealCrossDisplayShow) {
        this.setRealCrossDisplayShow = setRealCrossDisplayShow;
    }

    public boolean isSetModeCrossDisplayShow() {
        return setModeCrossDisplayShow;
    }

    public void setSetModeCrossDisplayShow(boolean setModeCrossDisplayShow) {
        this.setModeCrossDisplayShow = setModeCrossDisplayShow;
    }

    public boolean isSetTrafficInfoUpdateEnabled() {
        return setTrafficInfoUpdateEnabled;
    }

    public void setSetTrafficInfoUpdateEnabled(boolean setTrafficInfoUpdateEnabled) {
        this.setTrafficInfoUpdateEnabled = setTrafficInfoUpdateEnabled;
    }

    public boolean isSetTrafficLine() {
        return setTrafficLine;
    }

    public void setSetTrafficLine(boolean setTrafficLine) {
        this.setTrafficLine = setTrafficLine;
    }

    public boolean isShowTrafficButton() {
        return showTrafficButton;
    }

    public void setShowTrafficButton(boolean showTrafficButton) {
        this.showTrafficButton = showTrafficButton;
    }

    public boolean isShowTrafficBar() {
        return showTrafficBar;
    }

    public void setShowTrafficBar(boolean showTrafficBar) {
        this.showTrafficBar = showTrafficBar;
    }

    public boolean isShowBrowseRouteButton() {
        return showBrowseRouteButton;
    }

    public void setShowBrowseRouteButton(boolean showBrowseRouteButton) {
        this.showBrowseRouteButton = showBrowseRouteButton;
    }

    public boolean isShowMoreButton() {
        return showMoreButton;
    }

    public void setShowMoreButton(boolean showMoreButton) {
        this.showMoreButton = showMoreButton;
    }

    public boolean isUseComponent() {
        return isUseComponent;
    }

    public void setUseComponent(boolean useComponent) {
        isUseComponent = useComponent;
    }
}

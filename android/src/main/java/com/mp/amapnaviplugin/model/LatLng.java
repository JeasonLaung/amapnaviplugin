package com.mp.amapnaviplugin.model;

import java.io.Serializable;

public class LatLng implements Serializable {

    //这边暂定结束点这样
    private double latitude;
    private double longitude;

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
}

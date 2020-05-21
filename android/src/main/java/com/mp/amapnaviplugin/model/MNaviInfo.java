package com.mp.amapnaviplugin.model;

public class MNaviInfo {

    private int curStepRetainDistance;
    private String nextRoadName;
    private int pathRetainDistance;
    private int pathRetainTime;
    private byte[] iconBitmap;

    public int getCurStepRetainDistance() {
        return curStepRetainDistance;
    }

    public void setCurStepRetainDistance(int curStepRetainDistance) {
        this.curStepRetainDistance = curStepRetainDistance;
    }

    public String getNextRoadName() {
        return nextRoadName;
    }

    public void setNextRoadName(String nextRoadName) {
        this.nextRoadName = nextRoadName;
    }

    public int getPathRetainDistance() {
        return pathRetainDistance;
    }

    public void setPathRetainDistance(int pathRetainDistance) {
        this.pathRetainDistance = pathRetainDistance;
    }

    public int getPathRetainTime() {
        return pathRetainTime;
    }

    public void setPathRetainTime(int pathRetainTime) {
        this.pathRetainTime = pathRetainTime;
    }

    public byte[] getIconBitmap() {
        return iconBitmap;
    }

    public void setIconBitmap(byte[] iconBitmap) {
        this.iconBitmap = iconBitmap;
    }
}

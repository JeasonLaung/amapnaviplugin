//
//  AMapNavModel.swift
//  amapnaviplugin
//
//  Created by Mac on 2020/4/24.
//

import UIKit
import HandyJSON

class AMapNaviModel: NSObject, HandyJSON {
    required override init() {
    }
}

class NaviOptions: AMapNaviModel {
    
    //起点坐标
    var startLatLng:LatLng!
    
    //终点坐标
    var  endLatLng:LatLng!

    //    导航界面跟随模式，默认正北模式
    var  naviMode:Int!

    //    是否显示界面元素，默认false
    var  setLayoutVisible:Bool!

    //      设置导航状态下屏幕是否一直开启
    var setScreenAlwaysBright:Bool!

    //    走过的路线置灰
    var setAfterRouteAutoGray:Bool!

    //    设置6秒后是否自动锁车
    var setAutoLockCar:Bool!

    //    设置路线上的摄像头气泡是否显示
    var setCameraBubbleShow:Bool!
    
    //    设置是否显示路口放大图(实景图)
    var setRealCrossDisplayShow:Bool!

    //    设置是否显示路口放大图(路口模型图)
    var setModeCrossDisplayShow:Bool!

    var setTrafficInfoUpdateEnabled:Bool!

    //   是否绘制显示交通路况的线路
    var setTrafficLine:Bool!

    //    是否显示实时交通按钮，默认true
    var showTrafficButton:Bool!

    //    是否显示路况光柱，默认true
    var showTrafficBar:Bool!

    //    是否显示全览按钮，默认true
    var showBrowseRouteButton:Bool!

    //    是否显示更多按钮，默认true
    var showMoreButton:Bool!

    //    是否使用导航组件，默认false
    var isUseComponent:Bool!

}

class LatLng: AMapNaviModel {
    var latitude: CGFloat!
    var longitude: CGFloat!

}

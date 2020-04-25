import 'package:amapnaviplugin/models.dart';
import 'package:flutter/foundation.dart';

class AMapNaviMode {

  //车头朝北
  static const int carNorth = 0;

  //地图朝北
  static const int mapNorth = 1;
}

class AMapNaviOptions {
  //结束点
  final LatLng endLatLng;

  //    导航界面跟随模式，默认正北模式
  final int naviMode;

//    是否显示界面元素，默认false
  final bool setLayoutVisible;

//      设置导航状态下屏幕是否一直开启
  final bool setScreenAlwaysBright;

  //    走过的路线置灰
  final bool setAfterRouteAutoGray;

  //    设置6秒后是否自动锁车
  final bool setAutoLockCar;

  //    设置路线上的摄像头气泡是否显示
  final bool setCameraBubbleShow;

  //    设置是否显示路口放大图(实景图)
  final bool setRealCrossDisplayShow;

//    设置是否显示路口放大图(路口模型图)
  final bool setModeCrossDisplayShow;

  //  是否开启交通播报功能
  final bool setTrafficInfoUpdateEnabled;

  //   是否绘制显示交通路况的线路
  final bool setTrafficLine;

//    是否显示实时交通按钮，默认true
  final bool showTrafficButton;

//    是否显示路况光柱，默认true
  final bool showTrafficBar;

//    是否显示全览按钮，默认true
  final bool showBrowseRouteButton;

//    是否显示更多按钮，默认true
  final bool showMoreButton;

//    是否使用导航组件，默认false
  final bool isUseComponent;

  AMapNaviOptions(
      {@required this.endLatLng,
      this.naviMode = AMapNaviMode.carNorth,
      this.setLayoutVisible = false,
      this.setScreenAlwaysBright = true,
      this.setAfterRouteAutoGray = true,
      this.setAutoLockCar = true,
      this.setCameraBubbleShow = true,
      this.setRealCrossDisplayShow = false,
      this.setModeCrossDisplayShow = false,
      this.setTrafficInfoUpdateEnabled = true,
      this.setTrafficLine = true,
      this.showTrafficButton = true,
      this.showTrafficBar = true,
      this.showBrowseRouteButton = true,
      this.showMoreButton = true,
      this.isUseComponent = false});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.endLatLng != null) {
      data['endLatLng'] = this.endLatLng.toJson();
    }
    data['naviMode'] = this.naviMode;
    data['setLayoutVisible'] = this.setLayoutVisible;
    data['setScreenAlwaysBright'] = this.setScreenAlwaysBright;
    data['setAfterRouteAutoGray'] = this.setAfterRouteAutoGray;
    data['setAutoLockCar'] = this.setAutoLockCar;
    data['setCameraBubbleShow'] = this.setCameraBubbleShow;
    data['setRealCrossDisplayShow'] = this.setRealCrossDisplayShow;
    data['setModeCrossDisplayShow'] = this.setModeCrossDisplayShow;
    data['setTrafficLine'] = this.setTrafficLine;
    data['showTrafficButton'] = this.showTrafficButton;
    data['showTrafficBar'] = this.showTrafficBar;
    data['showBrowseRouteButton'] = this.showBrowseRouteButton;
    data['showMoreButton'] = this.showMoreButton;
    data['isUseComponent'] = this.isUseComponent;
    return data;
  }

//  AMapNaviOptions.fromJson(Map<String, dynamic> json) {
//    endLatLng = json['endLatLng'] != null
//        ? new EndLatLng.fromJson(json['endLatLng'])
//        : null;
//    naviMode = json['naviMode'];
//    showUIElements = json['showUIElements'];
//    showCrossDisplay = json['showCrossDisplay'];
//    showTrafficButton = json['showTrafficButton'];
//    showTrafficBar = json['showTrafficBar'];
//    showBrowseRouteButton = json['showBrowseRouteButton'];
//    showMoreButton = json['showMoreButton'];
//    isUseComponent = json['isUseComponent'];
//  }

}

import 'dart:convert';

import 'package:amapnaviplugin/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void NaviCloseHandler();
typedef void NaviMoreHandler();
typedef void NaviTouchMap();
typedef void CalculateRouteSuccess();
typedef void CalculateRouteFailure();

const String NaviChannelName = "com.mp.amapnaviplugin";

class AMapNaviController with WidgetsBindingObserver {
  final MethodChannel _naviChannel;
  final NaviCloseHandler onCloseHandler;
  final NaviMoreHandler onMoreHandler;
  final NaviTouchMap naviTouchMap;
  final CalculateRouteSuccess calculateRouteSuccess;
  final CalculateRouteFailure calculateRouteFailure;

  AMapNaviController( {
    int viewId,
    this.onCloseHandler,
    this.onMoreHandler,
    this.naviTouchMap,
    this.calculateRouteSuccess,
    this.calculateRouteFailure,
  }) : _naviChannel = MethodChannel('$NaviChannelName/$viewId');

//  final MethodChannel _componentChannel; //暂不接导航组件

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
  }

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    // TODO: implement didChangeAppLifecycleState
//    super.didChangeAppLifecycleState(state);
//    debugPrint('didChangeAppLifecycleState: $state');
//    // 因为这里的生命周期其实已经是App的生命周期了, 所以除了这里还需要在dispose里释放资源
//    switch (state) {
//      case AppLifecycleState.resumed:
//        androidController?.onResume();
//        break;
//      case AppLifecycleState.inactive:
//        break;
//      case AppLifecycleState.paused:
//        androidController?.onPause();
//        break;
//      case AppLifecycleState.detached:
//        androidController?.onDestroy();
//        break;
//    }
//  }

  Future startAMapNavi() {
    print("dart--> ${_naviChannel.name} --> startNavi ");

    return _naviChannel
        .invokeMethod('startNavi')
        .then((onValue) {
      return onValue;
    });
  }

  Future recoverLockMode() {
    print("dart--> ${_naviChannel.name} --> recoverLockMode ");

    return _naviChannel
        .invokeMethod('recoverLockMode')
        .then((onValue) {
      return onValue;
    });
  }

  Future displayOverview() {
    print("dart--> ${_naviChannel.name} --> displayOverview ");

    return _naviChannel
        .invokeMethod('displayOverview')
        .then((onValue) {
      return onValue;
    });
  }

  //native过来的回调
  void initNaviChannel(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);

    _naviChannel.setMethodCallHandler((handler) {
      switch (handler.method) {
        case 'close_navi':
          if (onCloseHandler != null) {
            onCloseHandler();
          } else {
            Navigator.of(context).pop();
          }
          break;
        case 'more_navi':
          if (onMoreHandler != null) {
            onMoreHandler();
          }
          break;
        case 'onCalculateRouteSuccess':
          print('dart 接收到 onCalculateRouteSuccess');
          if(calculateRouteSuccess!=null){
            calculateRouteSuccess();
          }
          break;
        case 'onCalculateRouteFailure':
          if(calculateRouteFailure!=null){
            calculateRouteFailure();
          }
          break;
        case 'touchMap':

        default:
          break;
      }
      return;
    });
  }
}

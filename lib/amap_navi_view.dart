import 'dart:convert';
import 'dart:io';

import 'package:amapnaviplugin/amap_navi_controller.dart';
import 'package:amapnaviplugin/amap_navi_options.dart';
import 'package:amapnaviplugin/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef void NaviViewCreateCallHandler(AMapNaviController controller);

const String viewType = 'com.mp.amapnaviplugin/AMapNaviView';

class AMapNaviView extends StatelessWidget {
  final NaviViewCreateCallHandler naviViewCreate;
  final AMapNaviOptions options;

  //回调返回事件
  final NaviCloseHandler naviCloseHandler;
  final NaviMoreHandler naviMoreHandler;
  final NaviTouchMap naviTouchMap;
  final CalculateRouteSuccess calculateRouteSuccess;
  final CalculateRouteFailure calculateRouteFailure;

  const AMapNaviView(
      {Key key,
      this.naviViewCreate,
      this.options,
      this.naviCloseHandler,
      this.naviMoreHandler, this.calculateRouteSuccess, this.calculateRouteFailure, this.naviTouchMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final gestureRecognizers = [
      Factory<OneSequenceGestureRecognizer>(
        () => EagerGestureRecognizer(),
      ),
    ].toSet();

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options == null
            ? jsonEncode(AMapNaviOptions(endLatLng: LatLng(0, 0)).toJson())
            : jsonEncode(options.toJson()),
        onPlatformViewCreated: platformViewCreated,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
      );
    } else if (Platform.isIOS) {
      return UiKitView(viewType: viewType,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: options == null
            ? jsonEncode(AMapNaviOptions(endLatLng: LatLng(0, 0)).toJson())
            : jsonEncode(options.toJson()),
        onPlatformViewCreated: platformViewCreated,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
      );
    } else {
      return Text(
        '插件未支持的平台',
      );
    }
  }

  void platformViewCreated(int viewId) {
    AMapNaviController _controller = AMapNaviController(
      viewId: viewId,
      onCloseHandler: naviCloseHandler,
      onMoreHandler: naviMoreHandler,
      naviTouchMap: naviTouchMap,
      calculateRouteSuccess: calculateRouteSuccess,
      calculateRouteFailure: calculateRouteFailure,
    );
    if (naviViewCreate != null) {
      naviViewCreate(_controller);
    }
  }
}

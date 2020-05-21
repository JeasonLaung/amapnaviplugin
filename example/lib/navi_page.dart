import 'dart:async';
import 'dart:typed_data';

import 'package:amapnaviplugin_example/trans_util.dart';
import 'package:flutter/material.dart';

import 'package:amapnaviplugin/amap_navi_controller.dart';
import 'package:amapnaviplugin/amap_navi_options.dart';
import 'package:amapnaviplugin/amap_navi_view.dart';
import 'package:amapnaviplugin/models.dart';
import 'package:amapnaviplugin/model/navi_info.dart';

class NaviPage extends StatefulWidget {
  @override
  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage>
    with SingleTickerProviderStateMixin {
  AMapNaviController _controller;
  PageController _pageController;
  TabController _tabController;
  double _height = 100;

  Uint8List _oldIconBitmap;

  final StreamController<NaviInfo> _streamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController?.close();
    super.dispose();
  }

  //对数据判断一下
  Widget directionIcon(Uint8List iconBitmap) {
    if (iconBitmap.isEmpty) {
      return Container();
    }
    if (_oldIconBitmap != iconBitmap) {
      _oldIconBitmap = iconBitmap;
    }
    return Container(
      height: 60,
      width: 60,
      child: Image.memory(Uint8List.fromList(_oldIconBitmap ?? []),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('地图导航'),
//      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          AMapNaviView(
            options: AMapNaviOptions(
              setLayoutVisible: true,
              setRealCrossDisplayShow:true,
              setModeCrossDisplayShow: true,
              startLatLng: LatLng(22.796803, 113.295822),
              endLatLng: LatLng(22.877388, 113.15887),
            ),
            naviViewCreate: (AMapNaviController controller) {
              _controller = controller;
              controller.initNaviChannel(context);
            },
            calculateRouteSuccess: () {
              print('路线规划成功');
              //路线规划成功
            },
            calculateRouteFailure: () {},
            naviMoreHandler: () {},
            naviCloseHandler: () {
              Navigator.of(context).pop();
            },
            naviTouchMap: () {
              print('摸了地图');
            },
            naviInfoHandler: (NaviInfo naviInfo) {
              _streamController?.sink?.add(naviInfo);
            },
          ),
//          StreamBuilder<NaviInfo>(
//              stream: _streamController.stream,
//              builder: (context, snapshot) {
//                NaviInfo _naviInfo = snapshot.data;
//                return _naviInfo != null
//                    ? Positioned(
//                        top: 0,
//                        child: Material(
//                            elevation: 8,
//                            color: Colors.black,
//                            child: Container(
//                              width: 400,
//                              height: 150,
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Row(
//                                    children: <Widget>[
//                                      directionIcon(Uint8List.fromList(
//                                          _naviInfo.iconBitmap??[])),
//                                      Column(
//                                        children: <Widget>[
//                                          Text(
//                                            '${TransUtil.distance(_naviInfo.curStepRetainDistance)} 进入',
//                                            style: TextStyle(
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                          Text(
//                                            '${_naviInfo.nextRoadName}',
//                                            style: TextStyle(
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                        ],
//                                      )
//                                    ],
//                                  ),
//                                  Text(
//                                    '剩余约${TransUtil.distance(_naviInfo.pathRetainDistance)}    预计${TransUtil.secToTime(_naviInfo.pathRetainTime)}',
//                                    style: TextStyle(
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  Builder(builder: (BuildContext context) {
//                                    DateTime d = DateTime.now().add(Duration(
//                                        seconds: _naviInfo.pathRetainTime));
//                                    return Text(
//                                        '预计${d.hour}:${d.minute < 10 ? '0${d.minute}' : d.minute}到达',
//                                        style: TextStyle(
//                                          color: Colors.white,
//                                        ));
//                                  })
//                                ],
//                              ),
//                            )),
//                      )
//                    : Container();
//              }),

        Positioned(
            bottom: 0,
            child: Container(
              color: Colors.black38,
          height: 200,
              width: 500,
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('退出导航'),
                  ),
                  MaterialButton(
                    onPressed: () {
//                        _controller.recoverLockMode();
                      _controller.startAMapNavi(); //开始导航
                    },
                    child: Text('开始导航'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _controller.displayOverview();
                    },
                    child: Text('全览'),
                  ),

                ],
              ),
        )),
        ],
      )),
    );
  }
}

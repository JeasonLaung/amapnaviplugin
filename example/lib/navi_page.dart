import 'package:flutter/material.dart';

import 'package:amapnaviplugin/amap_navi_controller.dart';
import 'package:amapnaviplugin/amap_navi_options.dart';
import 'package:amapnaviplugin/amap_navi_view.dart';
import 'package:amapnaviplugin/models.dart';

class NaviPage extends StatefulWidget {
  @override
  _NaviPageState createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> with SingleTickerProviderStateMixin{
  AMapNaviController _controller;
  PageController _pageController;
  TabController _tabController;
  double _height = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(

    );

    _tabController.addListener((){
      if(_tabController.index == 0){
        _height = 100;
        setState(() {

        });
      }else{
        _height = 200;
        setState(() {

        });
      }

      _pageController.animateToPage(_tabController.index, duration: Duration(milliseconds: 500), curve:Curves.ease);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('地图导航'),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          AMapNaviView(
            options: AMapNaviOptions(
              endLatLng: LatLng(22.877388, 113.15887),
            ),
            naviViewCreate: (AMapNaviController controller) {
              _controller = controller;
              controller.initNaviChannel(context);
            },
            calculateRouteSuccess: () {
              print('路线规划成功');
              //路线规划成功
              _controller.startAMapNavi(); //开始导航
            },
            calculateRouteFailure: () {},
            naviMoreHandler: () {},
            naviCloseHandler: () {},
            naviTouchMap: () {
              print('摸了地图');
            },
          ),
//
//          Container(
//            height: 100,
//            width: 200,
//            child: TabBar(
//                controller: _tabController,
//                tabs: [
//                  Tab(text: '111',),
//                  Tab(text: '222',
//                  ),
//                ]),
//          ),
//
//          Positioned(
//              top: 100,
//              child: Container(
//                height: _height,
//                width: 500,
//                child: PageView(
//                  controller: _pageController,
//                  children: <Widget>[
//                    Container(
//                      height: 200,
//                      width: 500,
//                      color: Colors.white,
//                    ),
//                    Container(
//                      height: 200,
//                      width: 500,
//                      color: Colors.red,
//                    ),
//                  ],
//                ),
//              )),
//
          Positioned(
              bottom: 0,
              child: Container(
                child: Row(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        _controller.recoverLockMode();
                      },
                      child: Text('锁车'),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _controller.displayOverview();
                      },
                      child: Text('全览'),
                    ),
                  ],
                ),
              ))
        ],
      )),
    );
  }
}

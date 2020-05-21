import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amapnaviplugin/amapnaviplugin.dart';

import 'navi_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Amapnaviplugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Builder(builder: (BuildContext context) {
            return Center(
                child: Column(
              children: <Widget>[
                Text('Running on: $_platformVersion\n'),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return NaviPage();
                    }));
                  },
                  child: Text('去导航页'),
                ),
                SlideButton(
                  height: 80,
                  width: 360,
                  percent: 0.7,
                  offset: Offset(0,0),
                  backgroundChild: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.blue[800],
                    child: Icon(Icons.check,color: Colors.white,),
                  ),
                  foregroundChild: Container(
                    height: 80,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 80,
                          child: Icon(Icons.forward,color: Colors.white,),
                        ),
                        Text('到达乘客上车点',style: TextStyle(
                          color: Colors.white,
                        ),),
                        SizedBox(
                          width: 80,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ));
          })),
    );
  }
}

class SlideButton extends StatefulWidget {

  //暂时先不加回弹动画效果 和 fling的处理
  final double height;
  final double width;
  final double percent; //滑动幅度 0-1
  final Offset offset;
  final Widget backgroundChild;
  final Widget foregroundChild;

  const SlideButton({Key key, this.height, this.width, this.percent = 0.5, this.offset, this.backgroundChild, this.foregroundChild})
      : super(key: key);

  @override
  _SlideButtonState createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  Offset _curOffset = Offset(0, 0);
  Offset _endOffset = Offset(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _curOffset = widget.offset;

  }

  @override
  void didUpdateWidget(SlideButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _curOffset = widget.offset;

  }

//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//    super.didChangeDependencies();
//    _curOffset = widget.offset;
//
//  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (DragDownDetails details) {
        //print('DragDownDetails:${details.toString()}');
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        print(
            'DragUpdateDetails: delta ${details.toString()} lacalPostion${details.localPosition}'
            'globalPosition${details.globalPosition}');

        setState(() {
          _curOffset = Offset(details.localPosition.dx, 0);
        });
      },
      onHorizontalDragCancel: () {
        print('onHorizontalDragCancel:');
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        setState(() {
          _endOffset = _curOffset;
          print('${_endOffset.dx}  ${widget.width} ');
          if(_endOffset.dx > widget.width * widget.percent){
            _curOffset = Offset(widget.width,0);
          }else{
            _curOffset = Offset(0, 0);
          }
        });

        print('DragEndDetails:${_endOffset.toString()}');
      },
      onHorizontalDragStart: (DragStartDetails details) {
        print('DragStartDetails:${details.toString()}');
//        setState(() {
//          _offset = Offset(details.localPosition.dx, 0);
//        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: <Widget>[
            widget.backgroundChild,
            Transform.translate(
              offset: _curOffset,
              child: widget.foregroundChild,
            ),
          ],
        ),
      ),
    );
  }
}

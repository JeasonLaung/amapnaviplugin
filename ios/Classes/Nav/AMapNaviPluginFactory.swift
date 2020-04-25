//
//  AMapNavPluginFactory.swift
//  amapnaviplugin
//
//  Created by Mac on 2020/4/24.
//

import Foundation
import AMapNaviKit


public class AMapNaviPluginFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var options:NaviOptions? = nil
        
        if let result = NaviOptions.deserialize(from: args as? String) {
            options = result
        }
        return FlutterAmapNavView.init(withFrame: frame, viewIdentifier: viewId, binaryMessenger: messenger, options: options)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
}

class FlutterAmapNavView: NSObject, FlutterPlatformView {
    fileprivate var viewId: Int64!
    fileprivate var methodChannel:FlutterMethodChannel!
    fileprivate var naviView:AMapNaviDriveView!
    fileprivate var naviOptions:NaviOptions!
    
    func view() -> UIView {
        return self.naviView ?? UIView()
    }
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, options: NaviOptions?) {
        super.init()
        
        //注册与flutter的通信
        methodChannel = FlutterMethodChannel.init(name: "\(Constants.NAVI_CHANNEL_NAME)/\(viewId)", binaryMessenger: binaryMessenger)
        methodChannel.setMethodCallHandler {[weak self] (call, result) in
            if let this = self {
                if !this.onMethodCall(call: call, result: result) {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        naviView = AMapNaviDriveView(frame: frame)
        naviView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        naviView.delegate = self
        
        naviOptions = options
        initializeOptions()
        
        // 创建 AMapNaviDriveManager
        AMapNaviDriveManager.sharedInstance().delegate = self
        
        AMapNaviDriveManager.sharedInstance().allowsBackgroundLocationUpdates = true
        AMapNaviDriveManager.sharedInstance().pausesLocationUpdatesAutomatically = false
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        AMapNaviDriveManager.sharedInstance().addDataRepresentative(naviView)
        
        //拿到坐标，开始算路
        print(String(format: "坐标:{latitude %f - longitude %f}", naviOptions.endLatLng.latitude, naviOptions.endLatLng.longitude))
        
        
        //        guard let arg = call.arguments as? String else {
        //            result("args is not string")
        //            return true
        //        }
        //
        //        guard let latlng = LatLng.deserialize(from: arg) else {
        //            result("args is not vaild json string")
        //            return true
        //        }
        
        let endPoint = AMapNaviPoint.location(withLatitude: naviOptions.endLatLng.latitude, longitude: naviOptions.endLatLng.longitude)!
        
        //进行路径规划
        AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withEnd: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault)
        
        
    }
    
    func initializeOptions() {
        if naviOptions != nil {
            
            //这里和android的类型调转了，区分一下
            if naviOptions.naviMode == 0 {
                //车头向北
                naviView.trackingMode = AMapNaviViewTrackingMode( rawValue: 0)!
            }else{
                naviView.trackingMode = AMapNaviViewTrackingMode( rawValue: 1)!
            }
            //
            //            naviView.trackingMode = AMapNaviViewTrackingMode(rawValue: (navOptions.naviMode)!)!
            
            naviView.showUIElements = naviOptions.setLayoutVisible
            naviView.showGreyAfterPass = naviOptions.setAfterRouteAutoGray
            naviView.autoSwitchShowModeToCarPositionLocked = naviOptions.setAutoLockCar//自动锁车
            naviView.showCamera = naviOptions.setCameraBubbleShow
            naviView.showCrossImage = naviOptions.setRealCrossDisplayShow
            //            naviView. = naviOptions.setTrafficInfoUpdateEnabled
            naviView.mapShowTraffic = naviOptions.setTrafficLine
            naviView.showTrafficButton = naviOptions.showTrafficButton
            naviView.showTrafficBar = naviOptions.showTrafficBar
            naviView.showBrowseRouteButton = naviOptions.showBrowseRouteButton
            naviView.showMoreButton = naviOptions.showMoreButton
        }
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        let method = call.method
        if method == "startNavi" {
            
            //flutter传过来 开始导航
            //            AMapNaviDriveManager.sharedInstance().startGPSNavi()
            AMapNaviDriveManager.sharedInstance().startEmulatorNavi()
            print("ios---> 开始导航 startNavi")
            result("success")
        } else if method == "recoverLockMode" {
            
            //锁车
            naviView.showMode = .carPositionLocked
            print("ios---> 锁车 recoverLockMode")
            
            result("success")
        }else if method == "displayOverview" {
            
            //显示全览
            naviView.showMode = .overview
            print("ios---> 全览 displayOverview")
            
            result("success")
        }else {
            return false
        }
        return true
    }
    
    deinit {
        releaseMap()
    }
    
    func releaseMap() {
        AMapNaviDriveManager.sharedInstance().stopNavi()
        AMapNaviDriveManager.sharedInstance().removeDataRepresentative(self.naviView)
        //停止语音
        SpeechSynthesizer.Shared.stopSpeak()
        AMapNaviDriveManager.sharedInstance().delegate = nil
        let isSuccess = AMapNaviDriveManager.destroyInstance()
        print("导航单例是否销毁成功：release--\(isSuccess)")
        self.naviView.removeFromSuperview()
        self.naviView.delegate = nil
    }
    
}

extension FlutterAmapNavView: AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate {
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onCalculateRouteSuccessWith type: AMapNaviRoutePlanType) {
        //算路成功后开始GPS导航 回调flutter算路成功
        
        methodChannel.invokeMethod("onCalculateRouteSuccess", arguments: nil)
        print("ios---> onCalculateRouteSuccess 算路成功")
        
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, error: Error) {
        //算路失败
        print(String(format: "算路失败 error:{%ld - %@}", Int(error._code), error.localizedDescription))
    }
    
    func driveViewCloseButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("close_navi", arguments: nil)
        print("ios--> close_navi")
    }
    
    func driveViewMoreButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("more_navi", arguments: nil)
        print("ios--> more_navi")
    }
    
    func driveManagerIsNaviSoundPlaying(_ driveManager: AMapNaviDriveManager) -> Bool {
        return SpeechSynthesizer.Shared.isSpeaking()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        NSLog("playNaviSoundString:{%d:%@}", soundStringType.rawValue, soundString);
        
        SpeechSynthesizer.Shared.speak(soundString)
    }
}

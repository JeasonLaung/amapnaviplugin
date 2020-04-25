//
//  AMapNavPluginFactory.swift
//  amapnaviplugin
//
//  Created by Mac on 2020/4/24.
//

import Foundation
import AMapNaviKit


public class AMapNavPluginFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var options:NavOptions? = nil
        
        if let result = NavOptions.deserialize(from: args as? String) {
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
    fileprivate var navOptions:NavOptions!
    
    func view() -> UIView {
        return self.naviView ?? UIView()
    }
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, options: NavOptions?) {
        super.init()
        
        naviView = AMapNaviDriveView(frame: frame)
        naviView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        naviView.delegate = self
        
        navOptions = options
        initializeOptions()
        
        // 创建 AMapNaviDriveManager
        AMapNaviDriveManager.sharedInstance().delegate = self
        
        AMapNaviDriveManager.sharedInstance().allowsBackgroundLocationUpdates = true
        AMapNaviDriveManager.sharedInstance().pausesLocationUpdatesAutomatically = false
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        AMapNaviDriveManager.sharedInstance().addDataRepresentative(navView)
        
        methodChannel = FlutterMethodChannel.init(name: "\(Constants.NAVI_CHANNEL_NAME)/\(viewId)", binaryMessenger: binaryMessenger)
        methodChannel.setMethodCallHandler {[weak self] (call, result) in
            if let this = self {
                if !this.onMethodCall(call: call, result: result) {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
    
    func initializeOptions() {
        if navOptions != nil {
            navView.trackingMode = AMapNaviViewTrackingMode(rawValue: (navOptions.naviMode)!)!
            navView.showUIElements = navOptions.set
            navView.showCrossImage = navOptions.showCrossImage
            navView.showTrafficButton = navOptions.showTrafficButton
            navView.showTrafficBar = navOptions.showTrafficBar
            navView.showBrowseRouteButton = navOptions.showBrowseRouteButton
            navView.showMoreButton = navOptions.showMoreButton
        }
    }
    
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        let method = call.method
        if method == "startNavi" {
            
            //flutter传过来 开始导航
            
//             AMapNaviDriveManager.sharedInstance().startGPSNavi()
            AMapNaviDriveManager.sharedInstance().startEmulatorNavi()
            
            guard let arg = call.arguments as? String else {
                result("args is not string")
                return true
            }
            
            guard let latlng = LatLng.deserialize(from: arg) else {
                result("args is not vaild json string")
                return true
            }
            
            let endPoint = AMapNaviPoint.location(withLatitude: latlng.latitude, longitude: latlng.longitude)!
            //进行路径规划
            AMapNaviDriveManager.sharedInstance().calculateDriveRoute(withEnd: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault)
            result("startNavi")
        } else {
            return false
        }
        return true
    }
    
    deinit {
        releaseMap()
    }
    
    func releaseMap() {
        AMapNaviDriveManager.sharedInstance().stopNavi()
        AMapNaviDriveManager.sharedInstance().removeDataRepresentative(self.navView)
        //停止语音
        SpeechSynthesizer.Shared.stopSpeak()
        AMapNaviDriveManager.sharedInstance().delegate = nil
        let isSuccess = AMapNaviDriveManager.destroyInstance()
        print("导航单例是否销毁成功：release--\(isSuccess)")
        self.navView.removeFromSuperview()
        self.navView.delegate = nil
    }
    
}

extension FlutterAmapNavView: AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate {
    
    func driveManager(_ driveManager: AMapNaviDriveManager, onCalculateRouteSuccessWith type: AMapNaviRoutePlanType) {
        //算路成功后开始GPS导航 回调flutter算路成功
        methodChannel.invokeMethod("onCalculateRouteSuccess", arguments: nil)
        print("ios-->算路成功")
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, error: Error) {
        //算路失败
        print(String(format: "error:{%ld - %@}", Int(error._code), error.localizedDescription))
    }
    
    func driveViewCloseButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("close_nav", arguments: nil)
    }
    
    func driveViewMoreButtonClicked(_ driveView: AMapNaviDriveView) {
        methodChannel.invokeMethod("more_nav", arguments: nil)
    }
    
    func driveManagerIsNaviSoundPlaying(_ driveManager: AMapNaviDriveManager) -> Bool {
        return SpeechSynthesizer.Shared.isSpeaking()
    }
    
    func driveManager(_ driveManager: AMapNaviDriveManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        NSLog("playNaviSoundString:{%d:%@}", soundStringType.rawValue, soundString);
        
        SpeechSynthesizer.Shared.speak(soundString)
    }
}

import Flutter
import UIKit

public class SwiftAmapnavipluginPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: Constants.NAVI_CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftAmapnavipluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

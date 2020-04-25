#import "AmapnavipluginPlugin.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#if __has_include(<amapnaviplugin/amapnaviplugin-Swift.h>)
#import <amapnaviplugin/amapnaviplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amapnaviplugin-Swift.h"
#endif

static NSString *AMAP_NAV_VIEW_CHANNEL = @"com.mp.amapnaviplugin/AMapNaviView";

@implementation AmapnavipluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapnavipluginPlugin registerWithRegistrar:registrar];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
     [AMapServices sharedServices].apiKey = @"b42fcb104694bde695a1551657bd7240";
    
    AMapNaviPluginFactory *naviFactory = [[AMapNaviPluginFactory alloc] initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:naviFactory withId:AMAP_NAV_VIEW_CHANNEL];
}
@end

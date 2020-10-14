#import "BackgroundgeolocationPlugin.h"
#if __has_include(<backgroundgeolocation/backgroundgeolocation-Swift.h>)
#import <backgroundgeolocation/backgroundgeolocation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "backgroundgeolocation-Swift.h"
#endif

@implementation BackgroundgeolocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackgroundgeolocationPlugin registerWithRegistrar:registrar];
}
@end

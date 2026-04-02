#import "CustomCameraPlugin.h"
#if __has_include(<custom_camera/custom_camera-Swift.h>)
#import <custom_camera/custom_camera-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "custom_camera-Swift.h"
#endif

@implementation CustomCameraPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCustomCameraPlugin registerWithRegistrar:registrar];
}
@end

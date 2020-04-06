#import "MochiMobilePlugin.h"
#import <mochi_mobile/mochi_mobile-Swift.h>

@implementation MochiMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMochiMobilePlugin registerWithRegistrar:registrar];
}
@end

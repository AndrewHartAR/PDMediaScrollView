//
//  PDMediaScollView
//  ProjectDent.com
//
//  Demo class
//  AppDelegate.m
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize demoVC = _demoVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    self.demoVC = [[DemoViewController alloc] init];
    [self.window addSubview:self.demoVC.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end

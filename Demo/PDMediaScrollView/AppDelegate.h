//
//  PDMediaScollView
//  ProjectDent.com
//
//  Demo class
//  AppDelegate.h
//

#import <UIKit/UIKit.h>
#import "DemoViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    DemoViewController *_demoVC;
    
}

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) DemoViewController *demoVC;

@end

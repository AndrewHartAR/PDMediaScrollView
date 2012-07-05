//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMediaViewController.h
//

#import <UIKit/UIKit.h>
#import "PDMediaScrollView.h"

@class PDMediaViewController;

@protocol PDMediaViewControllerDelegate <NSObject>

//This is useful for if you want your previous view controller to be showing the correct media item in a list when the user exits the media view controller
-(void)mediaViewController:(PDMediaViewController *)mediaViewController didChangeToEntryAtIndex:(int)index;

@optional
//This is useful if you want to use a custom navigation bar. You know when to show and remove it.
-(void)mediaViewController:(PDMediaViewController *)mediaViewController navigationBarDidChangeVisibilityToHidden:(BOOL)hidden;

@end

@interface PDMediaViewController : UIViewController {
    
    PDMediaScrollView *_mediaScrollView;
    
    __weak id <PDMediaViewControllerDelegate> _interactionDelegate;
    
    UINavigationBar *_navigationBar;
    
}

@property (nonatomic, strong) PDMediaScrollView *mediaScrollView;

@property (nonatomic, weak) id <PDMediaViewControllerDelegate> interactionDelegate;

@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

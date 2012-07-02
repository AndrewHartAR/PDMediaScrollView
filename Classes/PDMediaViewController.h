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

-(void)mediaViewController:(PDMediaViewController *)mediaViewController didChangeToEntryAtIndex:(int)index;

@end

@interface PDMediaViewController : UIViewController {
    
    PDMediaScrollView *_mediaScrollView;
    
    __weak id <PDMediaViewControllerDelegate> _interactionDelegate;
    
}

@property (nonatomic, strong) PDMediaScrollView *mediaScrollView;

@property (nonatomic, weak) id <PDMediaViewControllerDelegate> interactionDelegate;

@end

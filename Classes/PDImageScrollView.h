//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDImageScrollView.h
//

#import <UIKit/UIKit.h>

@class PDImageScrollView;

@protocol PDImageScrollViewTouchDelegate <NSObject>

@optional

-(void)didScrollInImageScrollView:(PDImageScrollView *)imageScrollView;
-(void)didZoomInImageScrollView:(PDImageScrollView *)imageScrollView;
-(void)didTouchUpInImageScrollView:(PDImageScrollView *)imageScrollView;

@end

@interface PDImageScrollView : UIScrollView {
    
    UIImageView *_imageView;
    
    __weak id <PDImageScrollViewTouchDelegate> _touchDelegate;
    
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id <PDImageScrollViewTouchDelegate> touchDelegate;

-(void)setImage:(UIImage *)image;

-(void)setupScales;
-(void)resetImageScale;

@end

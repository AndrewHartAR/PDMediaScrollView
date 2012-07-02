//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMovieScrollView.h
//

#import <UIKit/UIKit.h>

@class PDMovieView;

@protocol PDMovieViewDelegate <NSObject>

-(void)movieView:(PDMovieView *)movieView playFullScreenMovieWithURL:(NSURL *)movieURL;

@optional
-(void)didTapMovieView:(PDMovieView *)movieView;

@end

@interface PDMovieView : UIView {
    
    __weak id <PDMovieViewDelegate> _delegate;
    
    NSURL *_movieURL;
    
    UIImageView *_imageView;
    
}

@property (nonatomic, weak) id <PDMovieViewDelegate> delegate;

@property (nonatomic, strong) NSURL *movieURL;

@property (nonatomic, strong) UIImageView *imageView;

@end

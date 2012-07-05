//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMediaScrollView.h
//

#import <UIKit/UIKit.h>

typedef enum {
    PDMediaTypeImage,
    PDMediaTypeMovie
}PDMediaType;

@class PDMediaScrollView;

@protocol PDMediaScrollViewDelegate <NSObject>

-(int)numberOfMediaItemsInMediaScrollView:(PDMediaScrollView *)mediaScrollView;

@optional
-(PDMediaType)mediaScrollView:(PDMediaScrollView *)mediaScrollView mediaTypeForMediaAtIndex:(int)index;

-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView shouldReceiveMediaAtIndex:(int)index withFirstPriority:(BOOL)firstPriority;

@end

@protocol PDMediaScrollViewFullScreenDelegate <NSObject>

-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView playMovieFullScreenWithURL:(NSURL *)movieURL;

@end

@protocol PDMediaScrollViewTouchDelegate <NSObject>

@optional

-(void)didScrollInMediaScrollView:(PDMediaScrollView *)mediaScrollView;
-(void)didZoomInMediaScrollView:(PDMediaScrollView *)mediaScrollView;
-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView didChangeToPage:(int)page;
-(void)didTouchUpInMediaScrollView:(PDMediaScrollView *)mediaScrollView;

@end

@interface PDMediaScrollView : UIScrollView {
    
    __weak id <PDMediaScrollViewDelegate> _mediaDelegate;
    
    __weak id <PDMediaScrollViewTouchDelegate> _touchDelegate;
    __weak id <PDMediaScrollViewFullScreenDelegate> _fullScreenDelegate;
    
    int _currentMediaItem;
    NSCache *_mediaCache;
    
}

@property (nonatomic, weak) id <PDMediaScrollViewDelegate> mediaDelegate;

@property (nonatomic, weak) id <PDMediaScrollViewTouchDelegate> touchDelegate;

@property (nonatomic, weak) id <PDMediaScrollViewFullScreenDelegate> fullScreenDelegate;

@property (nonatomic, strong) NSCache *mediaCache;

@property (nonatomic) int currentMediaItem;

-(void)addImage:(UIImage *)image atIndex:(int)index;
-(void)addMovie:(NSURL *)movie atIndex:(int)index;
-(void)addMovie:(NSURL *)movie atIndex:(int)index withPreviewImage:(UIImage *)image;

@end

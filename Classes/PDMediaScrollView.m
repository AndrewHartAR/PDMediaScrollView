//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMediaScrollView.m
//

#import "PDMediaScrollView.h"
#import "PDImageScrollView.h"
#import "PDMovieView.h"

@interface PDMediaScrollView () <UIScrollViewDelegate, PDImageScrollViewTouchDelegate, PDMovieViewDelegate> {
    
    int _numberOfMediaItems;
    
    BOOL _frameIsChanging;
    
    NSMutableDictionary *_mediaViews;
    
}

@property (nonatomic) int numberOfMediaItems;

@property (nonatomic) BOOL frameIsChanging;

@property (nonatomic, strong) NSMutableDictionary *mediaViews;

@end

@implementation PDMediaScrollView

@synthesize numberOfMediaItems = _numberOfMediaItems;

@synthesize mediaDelegate = _mediaDelegate;

@synthesize touchDelegate = _touchDelegate;

@synthesize currentMediaItem = _currentMediaItem;

@synthesize mediaCache = _mediaCache;

@synthesize frameIsChanging = _frameIsChanging;

@synthesize fullScreenDelegate = _fullScreenDelegate;

@synthesize mediaViews = _mediaViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor blackColor];
        
        self.delegate = self;
        
        self.mediaCache = [[NSCache alloc] init];
        
        self.mediaViews = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)setup {
    self.numberOfMediaItems = [self.mediaDelegate numberOfMediaItemsInMediaScrollView:self];
    
    [self setupContentSize];
}

#pragma mark - Private methods

-(void)setupContentSize {
    self.contentSize = CGSizeMake(self.numberOfMediaItems * self.frame.size.width, self.frame.size.height);
}

-(void)retrieveMediaAtIndex:(int)index withFirstPriority:(BOOL)firstPriority {
    
    if ([self.mediaCache objectForKey:[NSNumber numberWithInt:index]]) {
        if ([self.mediaDelegate mediaScrollView:self mediaTypeForMediaAtIndex:index] == PDMediaTypeImage) {
            [self addImage:[self.mediaCache objectForKey:[NSNumber numberWithInt:index]] atIndex:index];
        }
        else {
            [self addMovie:[self.mediaCache objectForKey:[NSNumber numberWithInt:index]] atIndex:index];
        }
    }
    if ([self.mediaDelegate respondsToSelector:@selector(mediaScrollView:shouldReceiveMediaAtIndex:withFirstPriority:)]) {
        [self.mediaDelegate mediaScrollView:self shouldReceiveMediaAtIndex:index withFirstPriority:firstPriority];
    }
}

-(void)setupViewForViewingMediaAtIndex:(int)index {
    
    self.contentOffset = CGPointMake(self.frame.size.width * index, 0);
    
    [self retrieveMediaAtIndex:index withFirstPriority:YES];
    
    if ([self.mediaViews objectForKey:[NSNumber numberWithInt:index - 3]]) {
        [((UIView *)[self.mediaViews objectForKey:[NSNumber numberWithInt:index - 3]]) removeFromSuperview];
        [self.mediaViews removeObjectForKey:[NSNumber numberWithInt:index - 3]];
    }
    if ([self.mediaViews objectForKey:[NSNumber numberWithInt:index + 3]]) {
        [((UIView *)[self.mediaViews objectForKey:[NSNumber numberWithInt:index + 3]]) removeFromSuperview];
        [self.mediaViews removeObjectForKey:[NSNumber numberWithInt:index + 3]];
    }
    
    if (index > 0) {
        [self retrieveMediaAtIndex:index - 1 withFirstPriority:NO];
    }
    
    if (index > 1) {
        [self retrieveMediaAtIndex:index - 2 withFirstPriority:NO];
    }
    if (self.numberOfMediaItems > index + 1) {
        [self retrieveMediaAtIndex:index + 1 withFirstPriority:NO];
    }
    if (self.numberOfMediaItems > index + 2) {
        [self retrieveMediaAtIndex:index + 2 withFirstPriority:NO];
    }
    
    
}

-(CGRect)frameForMediaAtIndex:(int)index {
    
    CGRect frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    return frame;
}

-(void)addImage:(UIImage *)image atIndex:(int)index  {
    
    if ([self.mediaViews objectForKey:[NSNumber numberWithInt:index]]) {
            PDImageScrollView *imageScrollView = [self.mediaViews objectForKey:[NSNumber numberWithInt:index]];
            [imageScrollView resetImageScale];
    }
    else {
        CGRect frame = [self frameForMediaAtIndex:index];
        
        PDImageScrollView *imageScrollView = [[PDImageScrollView alloc] initWithFrame:frame];
        imageScrollView.touchDelegate = self;
        
        [imageScrollView setImage:image];
        
        [self.mediaCache setObject:image forKey:[NSNumber numberWithInt:index]];
        
        [self.mediaViews setObject:imageScrollView forKey:[NSNumber numberWithInt:index]];
        
        [self addSubview:imageScrollView];
    }
    
}

-(void)addMovie:(NSURL *)movie atIndex:(int)index {
    
    [self addMovie:movie atIndex:index withPreviewImage:nil];
    
}

-(void)addMovie:(NSURL *)movie atIndex:(int)index withPreviewImage:(UIImage *)image {
    
    if(![self.mediaViews objectForKey:[NSNumber numberWithInt:index]]) {
        CGRect frame = [self frameForMediaAtIndex:index];
        
        PDMovieView *movieView = [[PDMovieView alloc] initWithFrame:frame];
        movieView.delegate = self;
        
        movieView.imageView.image = image;
        
        [movieView setMovieURL:movie];
        
        [self.mediaCache setObject:movie forKey:[NSNumber numberWithInt:index]];
        
        [self.mediaViews setObject:movieView forKey:[NSNumber numberWithInt:index]];
        
        [self addSubview:movieView];
        
    }

}

-(void)frameIsChangingToNo {
    self.frameIsChanging = NO;
}

#pragma mark - Setter methods

-(void)setMediaDelegate:(id<PDMediaScrollViewDelegate>)mediaDelegate {
    _mediaDelegate = mediaDelegate;
    
    [self setup];
}

-(void)setCurrentMediaItem:(int)currentMediaItem {
    _currentMediaItem = currentMediaItem;
    if ([self.touchDelegate respondsToSelector:@selector(mediaScrollView:didChangeToPage:)]) {
        [self.touchDelegate mediaScrollView:self didChangeToPage:self.currentMediaItem];
    }
    [self setupViewForViewingMediaAtIndex:currentMediaItem];
}

-(void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    [self setupContentSize];
    
    self.contentOffset = CGPointMake(self.frame.size.width * self.currentMediaItem, 0);
    
    int i = 0;
    
    while (i < [self.mediaDelegate numberOfMediaItemsInMediaScrollView:self]) {
        
        if ([self.mediaViews objectForKey:[NSNumber numberWithInt:i]]) {
            UIView *view = [self.mediaViews objectForKey:[NSNumber numberWithInt:i]];
            view.frame = [self frameForMediaAtIndex:i];
        }
        i++;
    }
    
    /*
    self.frameIsChanging = YES;
    
    [self setupContentSize];
    
    self.contentOffset = CGPointMake(self.frame.size.width * self.currentMediaItem, 0);
    
    int i = 0;
    
    while (i < self.numberOfMediaItems) {
        
        UIView *view = [self.mediaCache objectForKey:[NSNumber numberWithInt:i]];
        
        view.frame = [self frameForMediaAtIndex:i];
        
        i++;
    }
    */
    
}

-(void)setFrameIsChanging:(BOOL)frameIsChanging {
    _frameIsChanging = frameIsChanging;
    
    if (self.frameIsChanging == YES) {
        [NSTimer scheduledTimerWithTimeInterval:0.3
                                         target:self
                                       selector:@selector(frameIsChangingToNo)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.touchDelegate respondsToSelector:@selector(didScrollInMediaScrollView:)]) {
        [self.touchDelegate didScrollInMediaScrollView:self];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int newPage = self.contentOffset.x / self.frame.size.width;
    if (newPage != self.currentMediaItem) {
        self.currentMediaItem = newPage;
    }
}

#pragma mark - PDImageScrollViewTouchDelegate methods

-(void)didScrollInImageScrollView:(PDImageScrollView *)imageScrollView {
    if (self.frameIsChanging == NO) {
        if ([self.touchDelegate respondsToSelector:@selector(didScrollInMediaScrollView:)]) {
            [self.touchDelegate didScrollInMediaScrollView:self];
        }
    }
}

-(void)didZoomInImageScrollView:(PDImageScrollView *)imageScrollView {
    if (self.frameIsChanging == NO) {
        if ([self.touchDelegate respondsToSelector:@selector(didZoomInMediaScrollView:)]) {
            [self.touchDelegate didZoomInMediaScrollView:self];
        }
    }
}

-(void)didTouchUpInImageScrollView:(PDImageScrollView *)imageScrollView {

    if ([self.touchDelegate respondsToSelector:@selector(didTouchUpInMediaScrollView:)]) {
        [self.touchDelegate didTouchUpInMediaScrollView:self];
    }
}

#pragma mark - JMovieViewTouchDelegate methods

-(void)didTapMovieView:(PDMovieView *)movieView {
    if ([self.touchDelegate respondsToSelector:@selector(didTouchUpInMediaScrollView:)]) {
        [self.touchDelegate didTouchUpInMediaScrollView:self];
    }
}

-(void)movieView:(PDMovieView *)movieView playFullScreenMovieWithURL:(NSURL *)movieURL {
    
    if ([self.fullScreenDelegate respondsToSelector:@selector(mediaScrollView:playMovieFullScreenWithURL:)]) {
        
        [self.fullScreenDelegate mediaScrollView:self playMovieFullScreenWithURL:movieURL];
    }
}

@end

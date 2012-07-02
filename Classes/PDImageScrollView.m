//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDImageScrollView.m
//

#import "PDImageScrollView.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface PDImageScrollView () <UIScrollViewDelegate> {
    
    float _zoomedInScale;
    float _naturalZoomScale;
    
    BOOL _touchUpOccurred;
    
}

@property (nonatomic) float zoomedInScale;

@property (nonatomic) float naturalZoomScale;

@property (nonatomic) BOOL touchUpOccurred;

@end

@implementation PDImageScrollView

@synthesize imageView = _imageView;

@synthesize zoomedInScale = _zoomedInScale, naturalZoomScale = _naturalZoomScale;

@synthesize touchUpOccurred = _touchUpOccurred;

@synthesize touchDelegate = _touchDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        self.scrollEnabled = YES;
        super.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
        
    }
    return self;
}

-(void)resetImageScale {
    self.zoomScale = self.naturalZoomScale;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    // Detect touch anywhere
    UITouch *touch = [touches anyObject];
    
    switch ([touch tapCount]) 
    {
        case 1:
            [self performSelector:@selector(oneTap) withObject:nil afterDelay:.5];
            self.touchUpOccurred = NO;
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
            [self performSelector:@selector(twoTaps) withObject:nil afterDelay:0];
            break;
            
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchUpOccurred = YES;
    
}

-(void)setupScales {
    self.maximumZoomScale = 1.3;
    
    CGSize screenSize = self.bounds.size;
    
    float difference;
    if (self.imageView.image.size.width / self.imageView.image.size.height < screenSize.width / screenSize.height) {
        self.minimumZoomScale = screenSize.height / self.imageView.image.size.height;
        self.zoomedInScale = screenSize.width / self.imageView.image.size.width;
        difference = (screenSize.height / screenSize.width) - (self.imageView.image.size.height / self.imageView.image.size.width);
    }
    else {
        self.minimumZoomScale = screenSize.width / self.imageView.image.size.width;
        self.zoomedInScale = screenSize.height / self.imageView.image.size.height;
        difference = (screenSize.width / screenSize.height) - (self.imageView.image.size.width / self.imageView.image.size.height);
    }
    
    if (difference > -0.1 && difference < 0.1) {
        self.naturalZoomScale = self.zoomedInScale;
        self.zoomedInScale = self.zoomedInScale * 2;
    }
    else {
        self.naturalZoomScale = self.minimumZoomScale;
    }
}

#pragma mark - Private methods

-(void)oneTap
{
    if (self.touchUpOccurred == YES) {
        if ([self.touchDelegate respondsToSelector:@selector(didTouchUpInImageScrollView:)]) {
            [self.touchDelegate didTouchUpInImageScrollView:self];
        }
    }
}

-(void)twoTaps
{
    if (self.zoomScale == self.naturalZoomScale || self.zoomScale == self.minimumZoomScale) {
        [self setZoomScale:self.zoomedInScale animated:YES];
    }
    else {
        [self setZoomScale:self.naturalZoomScale animated:YES];
    }
}

-(void)setDefaultContentSize {
    self.contentSize = self.frame.size;
    CGSize screenSize = self.bounds.size;
    if (self.imageView.frame.size.width > screenSize.width) {
        self.contentOffset = CGPointMake((self.imageView.frame.size.width - screenSize.width) / 2, 0);
    }
}

#pragma mark - Setter methods

-(void)setImage:(UIImage *)image {
    
    dispatch_queue_t queue = dispatch_queue_create("add_image", NULL);
    
    dispatch_async(queue, ^{
        UIImage *resizedImage = image;
        if (image.size.width > 1024 || image.size.height > 1024) {
            resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1024, 1024) interpolationQuality:kCGInterpolationHigh];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = resizedImage;
            self.imageView.frame = CGRectMake(0, 0, resizedImage.size.width, resizedImage.size.height);
            self.imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            [self setupScales];
            [self resetImageScale];
        });
        
    });
    
    dispatch_release(queue);
    
    
    
    
}

-(void)setZoomScale:(float)zoomScale {
    super.zoomScale = zoomScale;
    [self setDefaultContentSize];
}

-(void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    self.imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    
    [self setupScales];
    
    [self resetImageScale];
}

#pragma mark - UIScrollViewDelegate methods
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.touchDelegate respondsToSelector:@selector(didScrollInImageScrollView:)]) {
        [self.touchDelegate didScrollInImageScrollView:self];
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if ([self.touchDelegate respondsToSelector:@selector(didZoomInImageScrollView:)]) {
        [self.touchDelegate didZoomInImageScrollView:self];
    }
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if (scale == self.naturalZoomScale) {
        [self setDefaultContentSize];
    }
}

@end

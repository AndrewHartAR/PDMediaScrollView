//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMovieScrollView.m
//

#import "PDMovieView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Resize.h"

@interface PDMovieView () {
    
    MPMoviePlayerController *_moviePlayer;
    
    BOOL _waitingOnTouchUp;
    
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic) BOOL waitingOnTouchUp;

@end

@implementation PDMovieView

@synthesize imageView = _imageView;

@synthesize moviePlayer = _moviePlayer;

@synthesize waitingOnTouchUp = _waitingOnTouchUp;

@synthesize delegate = _delegate;

@synthesize movieURL = _movieURL;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        [playButton setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
        playButton.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        playButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [playButton addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton]; 
        
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    [self performSelector:@selector(tapLengthOver) withObject:nil afterDelay:.5];
    self.waitingOnTouchUp = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.waitingOnTouchUp == YES) {
        if ([self.delegate respondsToSelector:@selector(didTapMovieView:)]) {
            [self.delegate didTapMovieView:self];
        }
    }
}

#pragma mark - Private methods

-(void)tapLengthOver {
    self.waitingOnTouchUp = NO;
}

-(void)playPressed {
    if (self.movieURL != nil) {
        [self.delegate movieView:self playFullScreenMovieWithURL:self.movieURL];
        
    }
}

#pragma mark - Setter methods

-(void)setMovieURL:(NSURL *)movieURL {
    
    _movieURL = movieURL;
    
    //If the holding image isn't set first, then it sets it here.
    if (self.imageView.image == nil) {
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        UIImage *originalImage = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [moviePlayer stop];
        moviePlayer = nil;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *pathForFile = [movieURL path];
        
        if (![fileManager fileExistsAtPath:pathForFile]){ 
            NSLog(@"movie file doesn't exist");
        }
        
        dispatch_queue_t queue = dispatch_queue_create("add_placeholder_image", NULL);
        
        dispatch_async(queue, ^{
            
            UIImage *screenSizeImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                           bounds:CGSizeMake(1024, 1024)
                                                             interpolationQuality:kCGInterpolationHigh];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = screenSizeImage;
                
            });
            
        });
        
        dispatch_release(queue);
        
        
        
    }
    
}

@end

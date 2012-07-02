//
//  PDMediaScollView
//  ProjectDent.com
//
//  PDMediaViewController.m
//

#import "PDMediaViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PDMediaViewController () <PDMediaScrollViewTouchDelegate, PDMediaScrollViewFullScreenDelegate> {
    
    BOOL _statusBarHiddenInitially;
    UIStatusBarStyle _statusBarStyleInitially;
    
    BOOL _touchUpOccurred;
    
    BOOL _isVisible;
    
    UINavigationBar *_navigationBar;
    
    BOOL _keepNavigationBar;
    
}

@property (nonatomic) BOOL statusBarHiddenInitially;
@property (nonatomic) UIStatusBarStyle statusBarStyleInitially;

@property (nonatomic) BOOL touchUpOccurred;

@property (nonatomic) BOOL isVisible;

@property (nonatomic, strong) UINavigationBar *navigationBar;

@property (nonatomic) BOOL keepNavigationBar;

@end

@implementation PDMediaViewController

@synthesize mediaScrollView = _mediaScrollView;

@synthesize statusBarHiddenInitially = _statusBarHiddenInitially;

@synthesize statusBarStyleInitially = _statusBarStyleInitially;

@synthesize touchUpOccurred = _touchUpOccurred;

@synthesize isVisible = _isVisible;

@synthesize interactionDelegate = _interactionDelegate;

@synthesize navigationBar = _navigationBar;

@synthesize keepNavigationBar = _keepNavigationBar;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor blackColor];
        
        
        self.mediaScrollView = [[PDMediaScrollView alloc] initWithFrame:self.view.bounds];
        self.mediaScrollView.touchDelegate = self;
        self.mediaScrollView.fullScreenDelegate = self;
        [self.view addSubview:self.mediaScrollView];
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(done)];
        
        self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"0 of 0"];
        self.navigationBar.items = [NSArray arrayWithObject:navItem];
        self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationBar.topItem.rightBarButtonItem = button;
        
        [self.view addSubview:self.navigationBar];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isVisible = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}
    

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(potentiallyHideNavigationBar)
                                   userInfo:nil
                                    repeats:NO];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.isVisible = NO;
    
    [[UIApplication sharedApplication]setStatusBarHidden:self.statusBarHiddenInitially withAnimation:UIStatusBarAnimationNone];
    
    
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.mediaScrollView.frame = self.view.bounds;

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (self.isVisible == YES) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - Private methods

-(void)potentiallyHideNavigationBar {
    if (!self.keepNavigationBar) {
        [self hideNavigationBar];
    }
}

-(void)hideNavigationBar {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.navigationBar.alpha = 0;
                     }completion:nil];
}

-(void)showNavigationBar {
    
    self.keepNavigationBar = YES;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.navigationBar.alpha = 1.0;
                     }completion:nil];
}

-(void)done {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - JMediaScrollView methods

-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView didChangeToPage:(int)page {
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"%i of %i",
                                page + 1,
                                [self.mediaScrollView.mediaDelegate numberOfMediaItemsInMediaScrollView:self.mediaScrollView]];
    if (self.isVisible == YES) {
    [self.interactionDelegate mediaViewController:self didChangeToEntryAtIndex:page];
    }
}

-(void)didScrollInMediaScrollView:(PDMediaScrollView *)mediaScrollView {
    if (self.isVisible) {
    [self hideNavigationBar];
    }
}

-(void)didZoomInMediaScrollView:(PDMediaScrollView *)mediaScrollView {
    if (self.isVisible) {
    [self hideNavigationBar];
    }
}

-(void)didTouchUpInMediaScrollView:(PDMediaScrollView *)mediaScrollView {
    
    if (self.isVisible) {
        
        if (self.navigationBar.alpha == 0) {
            [self showNavigationBar];
        }
        else {
            [self hideNavigationBar];
        }
    }
}

-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView playMovieFullScreenWithURL:(NSURL *)movieURL {
    
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerController
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerController.moviePlayer];
    
    moviePlayerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:moviePlayerController animated:YES];
    
    [moviePlayerController.moviePlayer prepareToPlay];
    [moviePlayerController.moviePlayer play];
    
    self.isVisible = NO;
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self dismissModalViewControllerAnimated:YES];
        
        self.isVisible = YES;
    }
}

#pragma mark - Setter methods

-(void)setMediaScrollView:(PDMediaScrollView *)mediaScrollView {
    _mediaScrollView = mediaScrollView;
    
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.mediaScrollView.frame = self.view.bounds;
}

@end

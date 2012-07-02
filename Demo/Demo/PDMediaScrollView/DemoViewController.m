//
//  PDMediaScollView
//  ProjectDent.com
//
//  Demo class
//  DemoViewController.m
//

#import "DemoViewController.h"
#import "PDImageScrollView.h"
#import "PDMovieView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PDMediaViewController.h"

@interface DemoViewController () <PDMediaScrollViewDelegate> {
    PDMediaViewController* _mediaVC;
}

@property (nonatomic, strong) PDMediaViewController* mediaVC;

@end

@implementation DemoViewController

@synthesize mediaVC = _mediaVC;

- (id)init
{
    self = [super init];
    if (self) {
        /*
        PDImageScrollView *imageScrollView = [[PDImageScrollView alloc] initWithFrame:self.view.bounds];
        [imageScrollView setImage:[UIImage imageNamed:@"0.jpg"]];
        [self.view addSubview:imageScrollView];*/
        /*
        PDMovieView *movieView = [[PDMovieView alloc] initWithFrame:self.view.bounds];
        movieView.delegate = self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:path];
        
        movieView.movieURL = movieURL;
        [self.view addSubview:movieView];*/
        
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Tap me" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(50, 50, 120, 60);
        [self.view addSubview:button];
        
    }
    return self;
}


-(void)buttonTapped {

    
    self.mediaVC = [[PDMediaViewController alloc] init];
    self.mediaVC.mediaScrollView.mediaDelegate = self;
    self.mediaVC.mediaScrollView.currentMediaItem = 0;
    
    self.mediaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.mediaVC animated:YES];
    
}

#pragma mark - PDMediaScrollViewDelegate methods


-(int)numberOfMediaItemsInMediaScrollView:(id)mediaScrollView {
    return 6;
}

-(PDMediaType)mediaScrollView:(PDMediaScrollView *)mediaScrollView mediaTypeForMediaAtIndex:(int)index {
    if (index == 3) {
        return PDMediaTypeMovie;
    }
    else {
        return PDMediaTypeImage;
    }
}

-(UIImage *)mediaScrollView:(PDMediaScrollView *)mediaScrollView imageAtIndex:(int)index {
    NSLog(@"it wants an image");
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
}

-(NSURL *)mediaScrollView:(PDMediaScrollView *)mediaScrollView movieAtIndex:(int)index {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:path];
    
    return movieURL;
}

-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView shouldReceiveMediaAtIndex:(int)index withFirstPriority:(BOOL)firstPriority {
    if (index == 3) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:path];
        
        [self.mediaVC.mediaScrollView addMovie:movieURL atIndex:3];
    }
    else {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
        [self.mediaVC.mediaScrollView addImage:image atIndex:index];
    }
}






@end

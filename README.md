PDMediaScrollView
=================

Full screen multimedia gallery from Journalized. Similar to the full screen view in the iPhone Photos app. Zoom and pan around images, swipe between media items, play videos.

http://ProjectDent.com/Journalized

![](http://f.cl.ly/items/2l2x3J3u0u0O3W0O2b0v/github1.png)
![](http://f.cl.ly/items/2P1i0E0l462q2811273n/github2.png)
![](http://f.cl.ly/items/2P071p1H0r0U3y241943/github3.png)

Features:
- Scroll through videos and images.
- Pinch to zoom, pan around images.
- Auto-showing and hiding navigation bar. Shows when you single tap on an image. Hides when you zoom and scroll between media items.
- Threading support, to increase speed.
- Auto resizing of images, as images larger than 1024 are slow and aren't designed to be used in a UIImage.
- Play videos.
- Landscape support
- Automatic preview image generation for videos, if needed

Instructions:

1. Add the MediaPlayer and QuartzCore framework to your project.
2. Import the PDMediaViewController file.
3. Use this code to init:

<code>
    self.mediaVC = [[PDMediaViewController alloc] init];
    self.mediaVC.mediaScrollView.mediaDelegate = self;
    self.mediaVC.mediaScrollView.currentMediaItem = 0;
    
    self.mediaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.mediaVC animated:YES];
</code>

4. Respond to:

-(int)numberOfMediaItemsInMediaScrollView:(PDMediaScrollView *)mediaScrollView;
-(PDMediaType)mediaScrollView:(PDMediaScrollView *)mediaScrollView mediaTypeForMediaAtIndex:(int)index;
-(void)mediaScrollView:(PDMediaScrollView *)mediaScrollView shouldReceiveMediaAtIndex:(int)index withFirstPriority:(BOOL)firstPriority;

In response to FirstPriority, you should have something like this:

<code>
    if (index == 3) { //Movie
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSURL *movieURL = [NSURL fileURLWithPath:path];
        
        [self.mediaVC.mediaScrollView addMovie:movieURL atIndex:3];
    }
    else { //Images
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
        [self.mediaVC.mediaScrollView addImage:image atIndex:index];
    }
</code>
    
In other words, find out what type of media is needed, and add it at the index it asked for. If firstPriority is NO, it means the app isn't looking at that view yet, and you can run the code in the background, if you wish to.

Notes:

It comes with UIImage extensions from here:
http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/

If anybody knows any better code than this for resizing images then I'd be glad to swap them out.

Requires MediaPlayer framework and QuartzCore framework.

Comes with a play image. Feel free to switch it out with your own.

Known issues:
- Images jump slightly on zoom out.
- Occasional Positioning bugs.
- Occiasional multiple views showing the same item.
PDMediaScrollView
=================

Full screen multimedia gallery from Journalized. Similar to the full screen view in the iPhone Photos app. Zoom and pan around images, swipe between media items, play videos.

http://ProjectDent.com/Journalized

![](http://i.imgur.com/jINr7.jpg?1)
![](http://i.imgur.com/6BqHx.jpg?1)
![](http://i.imgur.com/hkZ3F.png?1)
![](http://i.imgur.com/unHEv.jpg?1)
![](http://i.imgur.com/9RtwY.jpg?1)

Features:
- Scroll through videos and images.
- Pinch to zoom, pan around images.
- Auto-showing and hiding navigation bar. Shows when you single tap on an image. Hides when you zoom and scroll between media items.
- Threading support, to increase speed.
- Auto resizing of images, as images larger than 1024 are slow and aren't designed to be used in a UIImage.
- Play videos.

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
//
//  ImportWindowController.h
//  SMK Editor
//
//  Created by Ian Sidor on 17/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TrackEditorWindow;

@interface ImportWindowController : NSWindowController
{
	TrackEditorWindow *_trackWindow;
}

@property(retain) TrackEditorWindow *trackWindow;

-(id)initWithTrackWindow:(TrackEditorWindow*)window;

@end

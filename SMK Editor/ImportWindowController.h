//
//  ImportWindowController.h
//  SMK Editor
//
//  Created by Ian Sidor on 17/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TrackEditorWindow;
@class ImportWindow;

@interface ImportWindowController : NSWindowController

@property(strong) TrackEditorWindow		*trackWindow;
@property(strong) ImportWindow			*importWindow;

-(id)initWithTrackWindow:(TrackEditorWindow*)window;

@end

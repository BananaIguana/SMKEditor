//
//  TrackEditorWindow.h
//  SMK Editor
//
//  Created by Ian Sidor on 02/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SMKTrackView;

@interface TrackEditorWindow : NSWindow

@property(weak) IBOutlet		NSPopUpButton		*trackSelector;
@property(weak) IBOutlet		SMKTrackView		*trackView;
@property(strong)				NSArray				*trackArray;
@property(weak) IBOutlet		NSButton			*checkOverlay;
@property(weak) IBOutlet		NSButton			*checkAI;

-(void)setTracks:(NSArray*)tracks;

@end

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

@property(weak)				IBOutlet NSPopUpButton		*trackSelector;
@property(nonatomic,strong)		NSArray						*trackArray;
@property(weak)				IBOutlet SMKTrackView		*trackView;

-(void)setTracks:(NSArray*)tracks;

@end

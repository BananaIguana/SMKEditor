//
//  AppDelegate.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMKTrackView;
@class TrackEditorWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSArray										*themes;
	NSArray										*tracks;
	NSArray										*karts;
}

@property(nonatomic,retain) NSArray				*themes;
@property(nonatomic,retain) NSArray				*tracks;
@property(nonatomic,retain) NSArray				*karts;

@property(retain) IBOutlet TrackEditorWindow	*window;
@property(assign) IBOutlet NSImageView			*imageTest;
@property(assign) IBOutlet NSButton				*button;
@property(assign) IBOutlet SMKTrackView			*trackView;
@property(assign) IBOutlet NSButton				*testWindow;
@property(assign) IBOutlet NSPanel				*paletteWindow;

@end

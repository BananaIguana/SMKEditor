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
@class ImportWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic,strong) NSArray				*themes;
@property(nonatomic,strong) NSArray				*tracks;
@property(nonatomic,strong) NSArray				*karts;

@property(strong) ImportWindowController		*importWindowController;
@property(strong) IBOutlet TrackEditorWindow	*window;
@property(weak) IBOutlet NSImageView			*imageTest;
@property(weak) IBOutlet NSButton				*button;
@property(weak) IBOutlet SMKTrackView			*trackView;
@property(weak) IBOutlet NSButton				*testWindow;
@property(weak) IBOutlet NSPanel				*paletteWindow;

@end

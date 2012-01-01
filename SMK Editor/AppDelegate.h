//
//  AppDelegate.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMKTrackView;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSArray *themes;
}

@property(nonatomic,retain) NSArray *themes;
@property(nonatomic,retain) NSArray *tracks;

@property(retain) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageTest;
@property (assign) IBOutlet NSButton *button;
@property (assign) IBOutlet SMKTrackView *trackView;

@end

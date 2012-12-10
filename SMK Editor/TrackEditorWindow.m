//
//  TrackEditorWindow.m
//  SMK Editor
//
//  Created by Ian Sidor on 02/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "TrackEditorWindow.h"
#import "SMKTrackView.h"
#import "RomTypes.h"

@implementation TrackEditorWindow

-(IBAction)trackSelectorChanged:(id)sender
{
	NSInteger index = [self.trackSelector indexOfSelectedItem];

	self.trackView.track = (self.trackArray)[index];
	
	[self.trackView setNeedsDisplay:YES];
}

-(void)setTracks:(NSArray*)tracks
{
	self.trackArray = tracks;

	NSMutableArray *trackNameArray = [[NSMutableArray alloc] initWithCapacity:kRomNumTracks];
	
	[tracks enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){

		[trackNameArray addObject:[obj description]];
	}];

	[self.trackSelector removeAllItems];
	[self.trackSelector addItemsWithTitles:trackNameArray];
}

-(IBAction)overlayButtonChanged:(NSButton*)sender
{
	BOOL toggle = ( sender.state == NSOnState ) ? YES : NO;
	
	[self.trackView setDrawOverlay:toggle];
}

-(IBAction)aiButtonChanged:(NSButton*)sender
{
	BOOL toggle = ( sender.state == NSOnState ) ? YES : NO;
	
	[self.trackView setDrawAI:toggle];
}

@end

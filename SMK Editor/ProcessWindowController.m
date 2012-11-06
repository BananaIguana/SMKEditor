//
//  ProcessWindowController.m
//  SMK Editor
//
//  Created by Ian Sidor on 06/02/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "ProcessWindowController.h"
#import "RomBase.h"
#import "DataRom+Helpers.h"
#import "SMKTrackView.h"

@implementation ProcessWindowController

@synthesize rom;
@synthesize trackEditor;
@synthesize progress;
@synthesize romBase;

-(void)windowDidLoad
{
    [super windowDidLoad];
	
	[self.progress startAnimation:nil];
	
#if 0
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doIt:) object:self];
	
	[thread start];
#else
	[self performSelector:@selector(doIt:) withObject:self];
#endif
}

-(void)finishThread
{
	[self.trackEditor setTracks:romBase.tracks];

	self.trackEditor.trackView.track			= (self.romBase.tracks)[2];
	[self.trackEditor.trackView setNeedsDisplay:YES];
	
	[self.trackEditor makeKeyAndOrderFront:nil];
	[self.window orderOut:nil];
}

-(void)doIt:(ProcessWindowController*)var
{
	self.romBase = [self.rom extract];

	[NSThread sleepForTimeInterval:1.0f];
	
	[self.progress setMinValue:0.0f];
	[self.progress setMaxValue:10.0f];
	[self.progress setIndeterminate:NO];

	for( int i = 0; i < 100; ++i )
	{
		[NSThread sleepForTimeInterval:0.015f];

		[self.progress incrementBy:0.1f];
	}
	
	[self performSelectorOnMainThread:@selector(finishThread) withObject:nil waitUntilDone:NO];
}

@end

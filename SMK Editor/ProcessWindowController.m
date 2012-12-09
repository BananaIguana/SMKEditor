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
#import "DataRomManager.h"

#define THREADED_PROCESSING

@implementation ProcessWindowController

-(void)windowDidLoad
{
    [super windowDidLoad];
	
	[self.progress startAnimation:nil];
	
#ifdef THREADED_PROCESSING
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doIt:) object:self];
	
	[thread start];
#else
	[self performSelector:@selector(doIt:) withObject:self];
#endif
}

-(void)finishThread
{
	[self.trackEditor setTracks:self.romBase.tracks];

	self.trackEditor.trackView.track			= (self.romBase.tracks)[2];
	[self.trackEditor.trackView setNeedsDisplay:YES];
	
	[self.trackEditor makeKeyAndOrderFront:nil];
	[self.window orderOut:nil];
}

-(void)doIt:(ProcessWindowController*)var
{
#ifdef THREADED_PROCESSING
	NSManagedObjectContext *context				= [[DataRomManager sharedInstance] threadedContext];
#else
	NSManagedObjectContext *context				= [DataRomManager sharedInstance].context;
#endif
	DataRom *rom								= [DataRom dataRomFromObjectID:self.romID viaManagedObjectContext:context];
	
	// If you are running threaded, you can prove the contents of the rom data is fine with the below line.

//	NSLog( @"%@", rom.rom );
		
	self.romBase								= [rom extract];
		
	[self performSelectorOnMainThread:@selector(finishThread) withObject:nil waitUntilDone:NO];
}

@end

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

@interface ProcessWindowController()

@property(assign) NSUInteger						currentExtraction;

@end

@implementation ProcessWindowController

-(void)windowDidLoad
{
    [super windowDidLoad];
	
	[self.progress startAnimation:nil];
	
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doIt:) object:self];
	
	[thread setStackSize:( 1024 * 1024 * 4 )];	
	[thread start];
}

-(void)finishThread
{
	[self.trackEditor setTracks:self.romBase.tracks];
	
	if( [self.romBase.tracks count] >= 2 )
	{
		self.trackEditor.trackView.track			= (self.romBase.tracks)[2];
		[self.trackEditor.trackView setNeedsDisplay:YES];
	}
	
	[self.trackEditor makeKeyAndOrderFront:nil];
	[self.window orderOut:nil];
}

-(void)doIt:(ProcessWindowController*)var
{
	NSManagedObjectContext *context				= [[DataRomManager sharedInstance] threadedContext];

	DataRom *rom								= [DataRom dataRomFromObjectID:self.romID viaManagedObjectContext:context];
		
	[rom extractWithDelegate:self];
}

#pragma mark -
#pragma mark DataRomExtractionProtocol

-(void)notifyExtractedObject:(id)obj
{
	[self.progress setIndeterminate:NO];
	[self.progress setUsesThreadedAnimation:YES];
	[self.progress incrementBy:1.0];
	
	// The below text string value doesn't work too well due to the main thread doing all the work.

	NSString *processingString					= [NSString stringWithFormat:@"Processing - %@", obj];

	[self.textProgress setStringValue:processingString];
	
	NSLog( @"Processing [%@] - %@", [obj class], obj );
}

-(void)notifyExtractionSteps:(NSUInteger)steps
{
	[self.progress setMinValue:0.0];
	[self.progress setMaxValue:(double)steps];
	
	self.currentExtraction						= 0;
}

-(void)notifyExtractionComplete:(RomBase*)rom
{
	self.romBase								= rom;

	[self finishThread];
}

@end

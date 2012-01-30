//
//  ImportWindow.m
//  SMK Editor
//
//  Created by Ian Sidor on 05/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "ImportWindow.h"
#import "DataRomManager.h"
#import "DataRom+Helpers.h"
#import "ImportDeleteWindowController.h"
#import "TrackEditorWindow.h"
#import "RomBase.h"
#import "SMKTrackView.h"

@implementation ImportWindow

@synthesize tableView;
@synthesize dataRom;
@synthesize selectedTableIndex;
@synthesize labelProjectName;
@synthesize labelCreated;
@synthesize labelUpdated;
@synthesize buttonImport;
@synthesize buttonClone;
@synthesize buttonDelete;
@synthesize buttonOpen;
@synthesize trackWindow;

-(void)commonSetup
{
	self.dataRom					= [[DataRomManager sharedInstance] queryRomEntries];
	self.selectedTableIndex			= -1;
}

-(id)init
{
	self = [super init];
	
	if( self )
	{
		[self commonSetup];
	}
	
	return( self );
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if( self )
	{
		[self commonSetup];
	}

	return( self );
}

-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	if( self )
	{
		[self commonSetup];	
	}
	
	return( self );
}

-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
	
	if( self )
	{
		[self commonSetup];	
	}
	
	return( self );
}

-(void)dealloc
{
	[dataRom release];

	[super dealloc];
}

-(IBAction)onTableViewEvent:(NSTableView*)sender
{
	self.selectedTableIndex			= [sender selectedRow];
	
	if( self.selectedTableIndex != -1 )
	{	
		DataRom *rom				= [self.dataRom objectAtIndex:self.selectedTableIndex];
		
		[self.labelProjectName setStringValue:rom.name];
		[self.labelCreated setStringValue:[rom.dateImported description]];
		[self.labelUpdated setStringValue:[rom.dateUpdated description]];

		[self.buttonClone setEnabled:YES];
		[self.buttonDelete setEnabled:YES];
		[self.buttonOpen setEnabled:YES];
	}
	else
	{
		[self.labelProjectName setStringValue:@""];
		[self.labelCreated setStringValue:@""];
		[self.labelUpdated setStringValue:@""];
		
		[self.buttonClone setEnabled:NO];
		[self.buttonDelete setEnabled:NO];
		[self.buttonOpen setEnabled:NO];
	}
}

-(IBAction)clickedImport:(NSButton*)sender
{
	NSOpenPanel *openPanel			= [NSOpenPanel openPanel];
	
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanSelectHiddenExtension:YES];
	[openPanel setCanHide:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setResolvesAliases:YES];
	[openPanel setAllowsMultipleSelection:NO];
	[openPanel setShowsHiddenFiles:NO];
	[openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"smc", nil]];
	
	[openPanel beginSheetModalForWindow:self completionHandler:^( NSInteger result ){
		
		if( result == NSFileHandlingPanelOKButton )
		{
			DataRomManager *romManager = [DataRomManager sharedInstance];
			
			for( NSURL *url in [openPanel URLs] )
			{			
				[romManager insertRomEntry:url];
			}
			
			self.dataRom = [[DataRomManager sharedInstance] queryRomEntries];
			
			[self.tableView reloadData];
		}
		else
		{
			// Clicked cancel...
		}
	}];
}

-(IBAction)clickedClone:(NSButton*)sender
{

}

-(IBAction)clickedOpen:(NSButton*)sender
{
	DataRom *rom = [self.dataRom objectAtIndex:self.selectedTableIndex];

	[self.trackWindow makeKeyAndOrderFront:nil];
	
	RomBase *romBase = [rom extract];

	self.trackWindow.trackView.track			= [romBase.tracks objectAtIndex:2];
	[self.trackWindow.trackView setNeedsDisplay:YES];
	
	[self orderOut:nil];
}

-(void)sheetDidEnd:(NSWindow*)sheet returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{

}

-(IBAction)clickedDelete:(NSButton*)sender
{
	ImportDeleteWindowController *window = [[ImportDeleteWindowController alloc] initWithWindowNibName:@"ImportDeleteWindow"];
	
	SEL selector = @selector(sheetDidEnd:returnCode:contextInfo:);
	
	[NSApp beginSheet:[window window] modalForWindow:self modalDelegate:self didEndSelector:selector contextInfo:NULL];
}

#pragma mark -
#pragma mark NSWindowDelegate

-(BOOL)windowShouldClose:(id)sender
{
	return( YES );
}

#pragma mark -
#pragma mark NSTableViewDelegate


#pragma mark -
#pragma mark NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView*)tableView
{
	return( [self.dataRom count] );
}

-(id)tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn*)tableColumn row:(NSInteger)row
{
	DataRom *data = [self.dataRom objectAtIndex:row];
	
	NSImage *image;
	
	switch( [data.region intValue] )
	{
		case kDataRomRegionEurope :		{	image = [NSImage imageNamed:@"eur_flag_256.png"];	}break;
		case kDataRomRegionUSA :		{	image = [NSImage imageNamed:@"usa_flag_256.png"];	}break;
		case kDataRomRegionJapan :		{	image = [NSImage imageNamed:@"jap_flag_256.png"];	}break;
		default :						{	image = [NSImage imageNamed:NSImageNameStopProgressTemplate];	}
	}
	
	data.icon = image;
	
	return( data );
}

@end

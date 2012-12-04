//
//  AppDelegate.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "AppDelegate.h"

#import "RomObjTheme.h"
#import "RomObjTileGroup.h"
#import "RomObjTile.h"
#import "RomObjTrack.h"
#import "RomObjKart.h"
#import "RomObjPalette.h"
#import "RomObjPaletteGroup.h"
#import "RomEUR.h"
#import "RomTypes.h"
#import "SMKTrackView.h"
#import "ImportWindowController.h"
#import "DataRomManager.h"
#import "DataRomTransformer.h"
#import "TrackEditorWindow.h"

@implementation AppDelegate

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
	// Insert code here to initialize your application

	{
		DataRomNameTransformer *transformer		= [[DataRomNameTransformer alloc] init];
		
		[NSValueTransformer setValueTransformer:transformer forName:@"DataRomNameTransformer"];
	}

	{
		DataRomIconTransformer *transformer		= [[DataRomIconTransformer alloc] init];
		
		[NSValueTransformer setValueTransformer:transformer forName:@"DataRomIconTransformer"];
	}

	self.importWindowController					= [[ImportWindowController alloc] initWithTrackWindow:self.window];

	[self.importWindowController showWindow:nil];
}

@end

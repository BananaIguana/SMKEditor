//
//  AppDelegate.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "AppDelegate.h"

#import "RomEUR.h"

@implementation AppDelegate

@synthesize window = _window;

-(void)dealloc
{
	[_window release];

    [super dealloc];
}

-(void)test
{
	NSUserDefaults *defaults			= [NSUserDefaults standardUserDefaults];

	NSString *romFile					= [defaults stringForKey:@"rom"];
	
	NSAssert( romFile, @"Setup your rom path as a command line arg. \"-rom <path_to_rom>\"" );

	NSData *rom							= [[NSData alloc] initWithContentsOfFile:romFile];

	NSAssert( rom, @"Failed to load ROM" );
			
	// Fake it as european.
		
	RomEUR *eurRom						= [[RomEUR alloc] initWithData:rom];
	
	// Output data to test
	
	NSLog( @"---------< HEADER >---------" );

	NSLog( @"Title					= %@", [eurRom objectFromHandle:kRomHandleTitle] );
	NSLog( @"Cartridge type			= %@", [eurRom objectFromHandle:kRomHandleCartridgeTypeOffset] );
	NSLog( @"Rom Size				= %@", [eurRom objectFromHandle:kRomHandleRomSizeOffset] );
	NSLog( @"Ram Size				= %@", [eurRom objectFromHandle:kRomHandleRamSizeOffset] );
	NSLog( @"Destination Code		= %@", [eurRom objectFromHandle:kRomHandleDestinationCodeOffset] );
	NSLog( @"Mask Rom Version		= %@", [eurRom objectFromHandle:kRomHandleMaskRomVerOffset] );
	NSLog( @"Complement Check Low	= %@", [eurRom objectFromHandle:kRomHandleComplementCheckLowOffset] );
	NSLog( @"Complement Check High	= %@", [eurRom objectFromHandle:kRomHandleComplementCheckHighOffset] );
	NSLog( @"Checksum Low			= %@", [eurRom objectFromHandle:kRomHandleChecksumLowOffset] );
	NSLog( @"Checksum High			= %@", [eurRom objectFromHandle:kRomHandleChecksumHighOffset] );
	NSLog( @"Marker Code 1			= %@", [eurRom objectFromHandle:kRomHandleMarkerCode1Offset] );
	NSLog( @"Marker Code 2			= %@", [eurRom objectFromHandle:kRomHandleMarkerCode2Offset] );
	NSLog( @"Game Code 1			= %@", [eurRom objectFromHandle:kRomHandleGameCode1Offset] );
	NSLog( @"Game Code 2			= %@", [eurRom objectFromHandle:kRomHandleGameCode2Offset] );
	NSLog( @"Game Code 3			= %@", [eurRom objectFromHandle:kRomHandleGameCode3Offset] );
	NSLog( @"Game Code 4			= %@", [eurRom objectFromHandle:kRomHandleGameCode4Offset] );
	NSLog( @"Expansion Ram Size		= %@", [eurRom objectFromHandle:kRomHandleExpansionRamSizeOffset] );
	NSLog( @"Special Version		= %@", [eurRom objectFromHandle:kRomHandleSpecialVersionOffset] );
	NSLog( @"Cartridge Type Sub		= %@", [eurRom objectFromHandle:kRomHandleCartridgeTypeSubNumOffset] );
	
	NSLog( @"---------< CUP STRINGS >---------" );

	NSLog( @"Mushroom Cup			= %@", [eurRom objectFromHandle:kRomHandleTextMushroomCup] );
	NSLog( @"Flower Cup				= %@", [eurRom objectFromHandle:kRomHandleTextFlowerCup] );
	NSLog( @"Star Cup				= %@", [eurRom objectFromHandle:kRomHandleTextStarCup] );
	NSLog( @"Special Cup			= %@", [eurRom objectFromHandle:kRomHandleTextSpecialCup] );
	
	NSLog( @"---------< TRACK STRINGS >---------" );
	
	NSLog( @"Mario Circuit			= %@", [eurRom objectFromHandle:kRomHandleTextMarioCircuit] );
	NSLog( @"Ghost Valley			= %@", [eurRom objectFromHandle:kRomHandleTextGhostValley] );
	NSLog( @"Dohnut Plains			= %@", [eurRom objectFromHandle:kRomHandleTextDohnutPlains] );
	NSLog( @"Bowser Castle			= %@", [eurRom objectFromHandle:kRomHandleTextBowserCastle] );
	NSLog( @"Vanilla Lake			= %@", [eurRom objectFromHandle:kRomHandleTextVanillaLake] );
	NSLog( @"Choco Island			= %@", [eurRom objectFromHandle:kRomHandleTextChocoIsland] );
	NSLog( @"Koopa Beach			= %@", [eurRom objectFromHandle:kRomHandleTextKoopaBeach] );
	NSLog( @"Battle Course			= %@", [eurRom objectFromHandle:kRomHandleTextBattleCourse] );
	NSLog( @"Rainbow Road			= %@", [eurRom objectFromHandle:kRomHandleTextRainbowRoad] );
	
	NSLog( @"---------< PALETTE GROUP >---------" );
	
	RomObjPaletteGroup *ghostValleyPaletteGroup			= [eurRom objectFromHandle:kRomHandlePaletteGroupGhostValley];
	
	NSLog( @"Desc = %@", ghostValleyPaletteGroup );
	
	NSLog( @"---------< TILE GROUP >---------" );

	RomObjTileGroup *commonTileSet						= [eurRom tileGroupFromHandle:kRomHandleDataTileSetCommon paletteGroup:ghostValleyPaletteGroup];

	[eurRom release];
	[rom release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
		
	[self test];
}

@end

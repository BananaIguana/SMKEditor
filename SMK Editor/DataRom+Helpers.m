//
//  DataRom+Helpers.m
//  SMK Editor
//
//  Created by Ian Sidor on 30/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "DataRom+Helpers.h"
#import "RomObjTheme.h"
#import "RomObjTileGroup.h"
#import "RomObjTile.h"
#import "RomObjTrack.h"
#import "RomObjKart.h"
#import "RomObjPalette.h"
#import "RomObjPaletteGroup.h"
#import "RomEUR.h"
#import "RomTypes.h"
#import "RomEUR.h"

@implementation DataRom (Helpers)

-(RomBase*)extract
{
	// Fake it as european for now...
		
	RomEUR *eurRom						= [[[RomEUR alloc] initWithData:self.rom] autorelease];
	
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
	
	NSLog( @"---------< THEME >---------" );
		
	NSMutableArray *themeArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumThemes];
	
	for( int i = 0; i < kRomNumThemes; ++i )
	{
		NSLog( @"Processing [THEME] %@", RomThemeToString( i ) );
		
		RomObjPaletteGroup *paletteGroup	= [eurRom objectFromHandle:( kRomHandlePaletteGroupGhostValley + i )];
		
		RomObjTileGroup *commonTileSet		= [eurRom tileGroupFromHandle:kRomHandleDataTileSetCommon paletteGroup:paletteGroup];
		
		RomObjTheme *theme					= [eurRom themeFromHandle:( kRomHandleTilesetGroupGhostValley + i ) commonTileGroup:commonTileSet paletteGroup:paletteGroup];

		[themeArray addObject:theme];
	}
	
	NSMutableArray *trackArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumTracks];
	
	for( int i = 0; i < kRomNumTracks; ++i )
	{
		NSLog( @"Processing [TRACK] %@", RomTrackToString( i ) );
		
		NSNumber *index						= (eurRom.romTrackThemeMappingArray)[i];
		
		RomObjTheme *theme					= themeArray[[index unsignedIntValue]];
		
		RomObjOverlay *overlay				= [eurRom overlayItemFromHandle:( kRomHandleOverlayMarioCircuit3 + i ) commonTileGroup:theme.tileGroupCommon];
	
		RomObjTrack *track					= [eurRom trackFromHandle:( kRomHandleTrackMarioCircuit3 + i ) trackTheme:theme trackOverlay:overlay];
		
		[track setTrackType:i];
		
		[trackArray addObject:track];
	}
	
	NSMutableArray *kartArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumKarts];
	
	for( int i = 0; i < kRomNumKarts; ++i )
	{
		NSLog( @"Processing [KART] %@", RomKartToString( i ) );
		
		RomObjTheme *t						= themeArray[0];
		RomObjPaletteGroup *pg				= t.paletteGroup;
		RomObjPalette *p					= (pg.paletteArray)[0];
		
		RomObjKart *kart					= [eurRom kartFromHandle:( kRomHandleKartMario + i ) palette:p];
		
		[kartArray addObject:kart];		
	}	

	eurRom.themes							= themeArray;
	eurRom.tracks							= trackArray;
	eurRom.karts							= kartArray;

	[themeArray release];
	[trackArray release];
	[kartArray release];
	
	return( eurRom );
}
@end

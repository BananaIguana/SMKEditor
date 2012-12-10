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
#import "RomObjOverlay.h"
#import "RomEUR.h"
#import "RomTypes.h"
#import "RomEUR.h"
#import "RomBase+Info.h"

#define DELEGATE_NOTIFY( obj )		{\
										if( [delegate respondsToSelector:@selector(notifyExtractedObject:)] )\
										{\
											[delegate notifyExtractedObject:obj];\
										}\
									}

@implementation DataRom (Helpers)

-(RomBase*)extractWithDelegate:(id<DataRomExtractionProtocol>)delegate
{
	if( [delegate respondsToSelector:@selector(notifyExtractionSteps:)] )
	{
		[delegate notifyExtractionSteps:( kRomNumThemes + kRomNumTracks + kRomNumKarts )];
	}

	// Fake it as european for now...
		
	RomEUR *eurRom						= [[RomEUR alloc] initWithData:self.rom];
	
	// Output data to test
	
	NSLog( @"---------< HEADER >---------" );

	NSLog( @"Title					= %@", [eurRom objectFromHandle:kRomHandleTitle] );
	NSLog( @"Cartridge type			= %@", [eurRom objectFromHandle:kRomHandleCartridgeTypeOffset] );
	NSLog( @"Rom Size				= %@", [eurRom objectFromHandle:kRomHandleRomSizeOffset] );
	NSLog( @"Ram Size				= %@", [eurRom objectFromHandle:kRomHandleRamSizeOffset] );
	NSLog( @"Destination Code		= %@", [eurRom objectFromHandle:kRomHandleDestinationCodeOffset] );
	NSLog( @"License Code			= %@", [eurRom objectFromHandle:kRomHandleLicenseeCodeOffset] );
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

	NSLog( @"---------< EXTENSIONS >---------" );
	
	NSLog( @"Country				= %@", [eurRom country] );
	
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
		RomObjPaletteGroup *paletteGroup	= [eurRom objectFromHandle:( kRomHandlePaletteGroupGhostValley + i )];

		RomObjTileGroup *commonTileSet		= [eurRom tileGroupFromHandle:kRomHandleDataTileSetCommon paletteGroup:paletteGroup];

		RomObjTheme *theme					= [eurRom themeFromHandle:( kRomHandleTilesetGroupGhostValley + i ) commonTileGroup:commonTileSet paletteGroup:paletteGroup];

		[themeArray addObject:theme];
		
		DELEGATE_NOTIFY( theme );
	}
	
	NSMutableArray *trackArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumTracks];
	
	for( int i = 0; i < kRomNumTracks; ++i )
	{
		NSNumber *index						= (eurRom.romTrackThemeMappingArray)[i];
		
		RomObjTheme *theme					= themeArray[[index unsignedIntValue]];
		
		RomObjOverlay *overlay				= [eurRom overlayItemFromHandle:( kRomHandleOverlayMarioCircuit3 + i ) commonTileGroup:theme.tileGroupCommon];
	
		RomObjTrack *track					= [eurRom trackFromHandle:( kRomHandleTrackMarioCircuit3 + i ) trackTheme:theme trackOverlay:overlay];
		
		[track setTrackType:i];
		
		[trackArray addObject:track];

		DELEGATE_NOTIFY( track );
	}
	
	NSMutableArray *kartArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumKarts];
	
	for( int i = 0; i < kRomNumKarts; ++i )
	{
		RomObjTheme *t						= themeArray[0];
		RomObjPaletteGroup *pg				= t.paletteGroup;
		RomObjPalette *p					= (pg.paletteArray)[0];
		
		RomObjKart *kart					= [eurRom kartFromHandle:( kRomHandleKartMario + i ) palette:p];

		[kartArray addObject:kart];

		DELEGATE_NOTIFY( kart );
	}

	eurRom.themes							= themeArray;
	eurRom.tracks							= trackArray;
	eurRom.karts							= kartArray;
	
	return( eurRom );
}

-(RomBase*)extract
{
	return( [self extractWithDelegate:nil] );
}

+(DataRom*)dataRomFromObjectID:(NSManagedObjectID*)romID viaManagedObjectContext:(NSManagedObjectContext*)context
{
	NSEntityDescription *desc							= [NSEntityDescription entityForName:@"DataRom" inManagedObjectContext:context];
	
	NSFetchRequest *request								= [[NSFetchRequest alloc] init];
	
	[request setEntity:desc];
	
	NSError *error = nil;
	NSArray *array										= [context executeFetchRequest:request error:&error];

	return( [array objectAtIndex:0] );
		
//
//	NSManagedObject *object					= [context objectWithID:romID];
//	
//	NSAssert( [object isKindOfClass:[DataRom class]], @"Unexpected class type." );
//
//	return( (DataRom*)object );
}

@end

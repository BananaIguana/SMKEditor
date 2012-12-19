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
#import "RomObjAIData.h"
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

-(void)extractWithDelegate:(id<DataRomExtractionProtocol>)delegate
{
	dispatch_async( dispatch_get_main_queue(), ^{

		if( [delegate respondsToSelector:@selector(notifyExtractionSteps:)] )
		{
			[delegate notifyExtractionSteps:(
				
				kRomNumThemes			+		// Themes
				kRomNumTracks			+		// Tracks
				kRomNumKarts			+		// Karts
				kRomNumTrackGPTracks			// AI Data
			)];
		}
	});

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
	
	dispatch_group_t group1					= dispatch_group_create();
	
	for( int i = 0; i < kRomNumThemes; ++i )
	{
		[themeArray addObject:[NSNull null]];

		dispatch_group_async( group1, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{

			RomObjPaletteGroup *paletteGroup	= [eurRom objectFromHandle:( kRomHandlePaletteGroupGhostValley + i )];

			RomObjTileGroup *commonTileSet		= [eurRom tileGroupFromHandle:kRomHandleDataTileSetCommon paletteGroup:paletteGroup];

			RomObjTheme *theme					= [eurRom themeFromHandle:( kRomHandleTilesetGroupGhostValley + i ) commonTileGroup:commonTileSet paletteGroup:paletteGroup];

			@synchronized( themeArray )
			{
				[themeArray replaceObjectAtIndex:i withObject:theme];
			}
			
			dispatch_async( dispatch_get_main_queue(), ^{

				DELEGATE_NOTIFY( theme );
			});
		});
	}
	
	NSMutableArray *aiArray					= [[NSMutableArray alloc] initWithCapacity:kRomNumTrackGPTracks];
	
	for( int i = 0; i < kRomNumAIData; ++i )
	{
		[aiArray addObject:[NSNull null]];

		dispatch_group_async( group1, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{

			RomObjAIData *aiData				= [eurRom aiDataFromHandle:( kRomHandleAIDataMarioCircuit3 + i )];

			[aiData setAiDataType:i];

			@synchronized( aiArray )
			{
				[aiArray replaceObjectAtIndex:i withObject:aiData];
			}

			dispatch_async( dispatch_get_main_queue(), ^{

				DELEGATE_NOTIFY( aiData );
			});
		});
	}
	
	dispatch_group_wait( group1, DISPATCH_TIME_FOREVER );
	
	dispatch_group_t group2					= dispatch_group_create();
	
	NSMutableArray *trackArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumTracks];
	
	for( int i = 0; i < kRomNumTracks; ++i )
	{
		[trackArray addObject:[NSNull null]];

		dispatch_group_async( group2, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{

			NSNumber *index						= (eurRom.romTrackThemeMappingArray)[i];
			
			RomObjTheme *theme					= themeArray[[index unsignedIntValue]];
			
			RomObjOverlay *overlay				= [eurRom overlayItemFromHandle:( kRomHandleOverlayMarioCircuit3 + i ) commonTileGroup:theme.tileGroupCommon];
		
			RomObjAIData *aiData				= nil;
			
			if( i < kRomNumAIData )
				aiData							= [aiArray objectAtIndex:i];
		
			RomObjTrack *track					= [eurRom trackFromHandle:( kRomHandleTrackMarioCircuit3 + i ) trackTheme:theme trackOverlay:overlay aiData:aiData];
			
			[track setTrackType:i];
			
			@synchronized( trackArray )
			{
				[trackArray replaceObjectAtIndex:i withObject:track];
			}

			dispatch_async( dispatch_get_main_queue(), ^{

				DELEGATE_NOTIFY( track );
			});
		});
	}
	
	NSMutableArray *kartArray				= [[NSMutableArray alloc] initWithCapacity:kRomNumKarts];
		
	for( int i = 0; i < kRomNumKarts; ++i )
	{
		[kartArray addObject:[NSNull null]];

		dispatch_group_async( group2, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
		
			RomObjTheme *t						= themeArray[0];
			RomObjPaletteGroup *pg				= t.paletteGroup;
			RomObjPalette *p;
			
			NSInteger mapping[]					= { 9, 8, 11, 11, 8, 10, 10, 9 };

			p									= [pg.paletteArray objectAtIndex:mapping[ i ]];
			
			RomObjKart *kart					= [eurRom kartFromHandle:( kRomHandleKartMario + i ) palette:p];

			@synchronized( kartArray )
			{
				[kartArray replaceObjectAtIndex:i withObject:kart];
			}

			dispatch_async( dispatch_get_main_queue(), ^{

				DELEGATE_NOTIFY( kart );
			});
		});
	}
	
	dispatch_group_wait( group2, DISPATCH_TIME_FOREVER );
	
	dispatch_async( dispatch_get_main_queue(), ^{

		eurRom.themes							= themeArray;
		eurRom.tracks							= trackArray;
		eurRom.karts							= kartArray;

		if( [delegate respondsToSelector:@selector(notifyExtractionComplete:)] )
		{
			[delegate notifyExtractionComplete:eurRom];
		}
	});
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

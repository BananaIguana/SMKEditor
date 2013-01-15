//
//  RomEUR.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomEUR.h"
#import "RomRange.h"
#import "RomTypes.h"
#import "NSValue+Rom.h"

// Cup Strings

static const RomRange kRomRangeTextMushroomCup					=		{ 0x1C924,		12,			12,			kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextFlowerCup					=		{ 0x1C931,		10,			10,			kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextStarCup						=		{ 0x1C93C,		8,			8,			kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextSpecialCup					=		{ 0x1C945,		11,			11,			kRomRangeTypeEncodedString };

// Track Strings

static const RomRange kRomRangeTextTheme[ kRomNumThemes ]		= {
																		{ 0x1C960,		12,			12,			kRomRangeTypeEncodedString },		// Ghost Valley
																		{ 0x1C951,		13,			13,			kRomRangeTypeEncodedString },		// Mario Circuit
																		{ 0x1C96E,		13,			13,			kRomRangeTypeEncodedString },		// Donut Plains
																		{ 0x1C999,		12,			12,			kRomRangeTypeEncodedString },		// Choco Island
																		{ 0x1C98B,		12,			12,			kRomRangeTypeEncodedString },		// Vanilla Lake
																		{ 0x1C9A7,		11,			11,			kRomRangeTypeEncodedString },		// Koopa Beach
																		{ 0x1C97C,		13,			13,			kRomRangeTypeEncodedString },		// Bowser Castle
																		{ 0x1C9C3,		12,			12,			kRomRangeTypeEncodedString },		// Rainbow Road
																};

static const RomRange kRomRangeTextBattleCourse					=		{ 0x1C9B4,		13,			13,			kRomRangeTypeEncodedString };

// Theme Palettes

static const RomRange kRomRangePaletteGroup[ kRomNumThemes ]	= {
																		{ 0x41313,		433,		433,		kRomRangeTypePaletteGroup },		// Ghost Valley
																		{ 0x4117F,		404,		404,		kRomRangeTypePaletteGroup },		// Mario Ciruit
																		{ 0x414C4,		433,		433,		kRomRangeTypePaletteGroup },		// Donut Plains
																		{ 0x419C0,		411,		411,		kRomRangeTypePaletteGroup },		// Choco Island
																		{ 0x4182F,		401,		401,		kRomRangeTypePaletteGroup },		// Vanilla Lake
																		{ 0x41B5B,		432,		432,		kRomRangeTypePaletteGroup },		// Koopa Beach
																		{ 0x41675,		442,		442,		kRomRangeTypePaletteGroup },		// Bowser Castle
																		{ 0x41D0B,		422,		422,		kRomRangeTypePaletteGroup },		// Rainbow Road
																};

// Common Tile Offset 

static const RomRange kRomRangeTileCommon						=		{ 0x40000,		1428,		0x4E0,		kRomRangeTypeCompressedData };

// Theme Tile Offset 

static const RomRange kRomRangeTileset[ kRomNumThemes ]			= {
																		{ 0x60189,		921,		921,		kRomRangeTypeCompressedData },
																		{ 0x481C9,		3489,		3489,		kRomRangeTypeCompressedData },
																		{ 0x50000,		3141,		3141,		kRomRangeTypeCompressedData },
																		{ 0x78000,		2667,		2667,		kRomRangeTypeCompressedData },
																		{ 0x014EE,		2654,		2654,		kRomRangeTypeCompressedData },
																		{ 0x51636,		2445,		2445,		kRomRangeTypeCompressedData },
																		{ 0x48F6A,		3250,		3250,		kRomRangeTypeCompressedData },
																		{ 0x41EBB,		276,		276,		kRomRangeTypeCompressedData },
																};

// Tracks

static const RomRange kRomRangeTracks[ kRomNumTracks ]			= {
																		{ 0x68000,		3372,		3372,		kRomRangeTypeTrack },
																		{ 0x7E821,		1306,		1306,		kRomRangeTypeTrack },
																		{ 0x6A823,		5957,		5957,		kRomRangeTypeTrack },
																		{ 0x7C527,		4312,		4312,		kRomRangeTypeTrack },
																		{ 0x6BF68,		41880,		4188,		kRomRangeTypeTrack },
																		{ 0x3EAD1,		1326,		1326,		kRomRangeTypeTrack },
																		{ 0x3D551,		5504,		5504,		kRomRangeTypeTrack },
																		{ 0x68D2C,		2047,		2047,		kRomRangeTypeTrack },
																		{ 0x6A245,		1502,		1502,		kRomRangeTypeTrack },
																		{ 0x7D5FF,		4642,		4642,		kRomRangeTypeTrack },
																		{ 0x6CFC4,		4586,		4586,		kRomRangeTypeTrack },
																		{ 0x78A6B,		5910,		5910,		kRomRangeTypeTrack },
																		{ 0x3103C,		3907,		3907,		kRomRangeTypeTrack },
																		{ 0x6E1AE,		4484,		4484,		kRomRangeTypeTrack },
																		{ 0x6952B,		3354,		3354,		kRomRangeTypeTrack },
																		{ 0x50C45,		2545,		2545,		kRomRangeTypeTrack },
																		{ 0x6F5BF,		1204,		1204,		kRomRangeTypeTrack },
																		{ 0x7B825,		3330,		3330,		kRomRangeTypeTrack },
																		{ 0x77251,		3501,		3501,		kRomRangeTypeTrack },
																		{ 0x7A181,		5796,		5796,		kRomRangeTypeTrack },
																		{ 0x214EE,		631,		631,		kRomRangeTypeTrack },
																		{ 0x7ED3B,		1106,		1106,		kRomRangeTypeTrack },
																		{ 0x6F338,		647,		647,		kRomRangeTypeTrack },
																		{ 0x21765,		798,		798,		kRomRangeTypeTrack },
																};

// Overlays

static const RomRange kRomRangeOverlays[ kRomNumTracks ]		= {
																		{ 0x5D000,		90,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D080,		105,		0x80,		kRomRangeTypeTrack },
																		{ 0x5D100,		81,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D180,		90,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D200,		87,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D280,		108,		0x80,		kRomRangeTypeTrack },
																		{ 0x5D300,		75,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D380,		63,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D400,		87,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D480,		96,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D500,		66,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D580,		81,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D600,		78,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D680,		93,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D700,		81,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D780,		96,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D800,		84,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D880,		84,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D900,		87,			0x80,		kRomRangeTypeTrack },
																		{ 0x5D980,		90,			0x80,		kRomRangeTypeTrack },
																		{ 0x5DA00,		120,		0x80,		kRomRangeTypeTrack },
																		{ 0x5DA80,		99,			0x80,		kRomRangeTypeTrack },
																		{ 0x5DB00,		105,		0x80,		kRomRangeTypeTrack },
																		{ 0x5DB80,		105,		0x80,		kRomRangeTypeTrack },
																};

static const RomRange kRomRangeAIZone[ kRomNumTrackGPTracks ] = {
																		{ 0x60526,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x606F3,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x6084E,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x6097D,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x60B84,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x60C6D,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x60DD2,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x60ECB,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x60FB4,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x6111D,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x612B6,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x6139F,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x614B0,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x61573,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x61692,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x617D9,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x618EC,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x619F1,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x61B0A,		100,		100,		kRomRangeTypeAIZone },
																		{ 0x61BED,		100,		100,		kRomRangeTypeAIZone },
																};

static const RomRange kRomRangeAITarget[ kRomNumTrackGPTracks ] = {
																		{ 0x6063F,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x607C7,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x6090B,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x60ABE,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x60C16,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x60D48,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x60E6E,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x60F5A,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61093,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x6121D,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61348,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61447,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61528,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61626,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x6175E,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61883,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x6198E,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61AA1,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61B96,		100,		100,		kRomRangeTypeAITarget },
																		{ 0x61CA9,		100,		100,		kRomRangeTypeAITarget },
																};

// Karts

static const RomRange kRomRangeKarts[ kRomNumKarts ]			= {
																		{ 0x02000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Mario
																		{ 0x12000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Bowser
																		{ 0x22000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Princess
																		{ 0x32000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Donkey Kong Jnr.
																		{ 0x42000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Yoshi
																		{ 0x4A000,		0x2000,		0x2000,		kRomRangeTypeKart },		// Luigi (special case - slightly more than 0x2000 in size, exact size to be determined)
																		{ 0x52000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Koopa
																		{ 0x62000,		0x6000,		0x6000,		kRomRangeTypeKart },		// Toad
																};

@implementation RomEUR

-(NSDictionary*)offsetDictionary
{
	NSMutableDictionary *dictionary	= [NSMutableDictionary dictionaryWithObjectsAndKeys:

		// Cup Strings

		[NSValue valueWithRomRange:kRomRangeTextMushroomCup],				[NSNumber numberWithUnsignedInt:kRomHandleTextMushroomCup],
		[NSValue valueWithRomRange:kRomRangeTextFlowerCup],					[NSNumber numberWithUnsignedInt:kRomHandleTextFlowerCup],
		[NSValue valueWithRomRange:kRomRangeTextStarCup],					[NSNumber numberWithUnsignedInt:kRomHandleTextStarCup],
		[NSValue valueWithRomRange:kRomRangeTextSpecialCup],				[NSNumber numberWithUnsignedInt:kRomHandleTextSpecialCup],

		// Track Strings (not themed)
		
		[NSValue valueWithRomRange:kRomRangeTextBattleCourse],				[NSNumber numberWithUnsignedInt:kRomHandleTextBattleCourse],
		
		// Common Tile Offset

		[NSValue valueWithRomRange:kRomRangeTileCommon],					[NSNumber numberWithUnsignedInt:kRomHandleDataTileSetCommon],
				
		nil];

	// Theme based handles
		
	for( kRomTheme eTheme = 0; eTheme < kRomNumThemes; ++eTheme )
	{
		// Theme text

		kRomHandle handleThemeText			= kRomHandleTextGhostValley + eTheme;
		
		dictionary[[NSNumber numberWithUnsignedInt:handleThemeText]] = [NSValue valueWithRomRange:kRomRangeTextTheme[ eTheme ]];

		// Theme Tilesets
		
		kRomHandle handleThemeTileset		= kRomHandleTilesetGroupGhostValley + eTheme;
		
		dictionary[[NSNumber numberWithUnsignedInt:handleThemeTileset]] = [NSValue valueWithRomRange:kRomRangeTileset[ eTheme ]];
		
		// Theme Palettes

		kRomHandle handleThemePalette		= kRomHandlePaletteGroupGhostValley + eTheme;

		dictionary[[NSNumber numberWithUnsignedInt:handleThemePalette]] = [NSValue valueWithRomRange:kRomRangePaletteGroup[ eTheme ]];
	}
	
	// Track handles
	
	for( kRomTrack eTrack = 0; eTrack < kRomNumTracks; ++eTrack )
	{
		kRomHandle handleTrack				= kRomHandleTrackMarioCircuit3 + eTrack;
		
		dictionary[[NSNumber numberWithUnsignedInt:handleTrack]] = [NSValue valueWithRomRange:kRomRangeTracks[ eTrack ]];
		
		kRomHandle handleOverlay			= kRomHandleOverlayMarioCircuit3 + eTrack;
		
		dictionary[[NSNumber numberWithUnsignedInt:handleOverlay]] = [NSValue valueWithRomRange:kRomRangeOverlays[ eTrack ]];
	}
	
	// AI Data
	
	for( kRomAIData eAIData = 0; eAIData < kRomNumAIData; ++eAIData )
	{
		kRomHandle handleAIData				= kRomHandleAIDataMarioCircuit3 + eAIData;
		
		NSValue *valueZone					= [NSValue valueWithRomRange:kRomRangeAIZone[ eAIData ]];
		NSValue *valueTarget				= [NSValue valueWithRomRange:kRomRangeAITarget[ eAIData ]];
		
		dictionary[[NSNumber numberWithUnsignedInt:handleAIData]] = @[ valueZone, valueTarget ];
	}
	
	// Kart handles
	
	for( kRomKart eKart = 0; eKart < kRomNumKarts; ++eKart )
	{
		kRomHandle handleKart				= kRomHandleKartMario + eKart;
		
		dictionary[[NSNumber numberWithUnsignedInt:handleKart]] = [NSValue valueWithRomRange:kRomRangeKarts[ eKart ]];
	}
	
	// Add parent common header information
	
	[dictionary addEntriesFromDictionary:[super offsetDictionary]];

	return( dictionary );
}

@end

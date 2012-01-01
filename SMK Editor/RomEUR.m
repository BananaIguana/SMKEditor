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

// Rom Header

static const RomRange kRomRangeTitle							=		{ 0xFFC0,		16,		21,		kRomRangeTypeString };
static const RomRange kRomRangeCartridgeTypeOffset				=		{ 0xFFD6,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeRomSizeOffset					=		{ 0xFFD7,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeRamSizeOffset					=		{ 0xFFD8,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeDestinationCodeOffset			=		{ 0xFFD9,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMaskRomVerOffset					=		{ 0xFFDB,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckLowOffset			=		{ 0xFFDC,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckHighOffset		=		{ 0xFFDD,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeChecksumLowOffset				=		{ 0xFFDE,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeChecksumHighOffset				=		{ 0xFFDF,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode1Offset				=		{ 0xFFB0,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode2Offset				=		{ 0xFFB1,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode1Offset					=		{ 0xFFB2,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode2Offset					=		{ 0xFFB3,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode3Offset					=		{ 0xFFB4,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode4Offset					=		{ 0xFFB5,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeExpansionRamSizeOffset			=		{ 0xFFBD,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeSpecialVersionOffset				=		{ 0xFFBE,		1,		1,		kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeCartridgeTypeSubNumOffset		=		{ 0xFFBF,		1,		1,		kRomRangeTypeUnsignedChar };

// Cup Strings

static const RomRange kRomRangeTextMushroomCup					=		{ 0x1C924,		12,		12,		kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextFlowerCup					=		{ 0x1C931,		10,		10,		kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextStarCup						=		{ 0x1C93C,		8,		8,		kRomRangeTypeEncodedString };
static const RomRange kRomRangeTextSpecialCup					=		{ 0x1C945,		11,		11,		kRomRangeTypeEncodedString };

// Track Strings

static const RomRange kRomRangeTextTheme[ kRomNumThemes ]		= {
																		{ 0x1C960,		12,		12,		kRomRangeTypeEncodedString },		// Ghost Valley
																		{ 0x1C951,		13,		13,		kRomRangeTypeEncodedString },		// Mario Circuit
																		{ 0x1C96E,		13,		13,		kRomRangeTypeEncodedString },		// Donut Plains
																		{ 0x1C999,		12,		12,		kRomRangeTypeEncodedString },		// Choco Island
																		{ 0x1C98B,		12,		12,		kRomRangeTypeEncodedString },		// Vanilla Lake
																		{ 0x1C9A7,		11,		11,		kRomRangeTypeEncodedString },		// Koopa Beach
																		{ 0x1C97C,		13,		13,		kRomRangeTypeEncodedString },		// Bowser Castle
																		{ 0x1C9C3,		12,		12,		kRomRangeTypeEncodedString },		// Rainbow Road
																};

static const RomRange kRomRangeTextBattleCourse					=		{ 0x1C9B4,		13,		13,		kRomRangeTypeEncodedString };

// Theme Palettes

static const RomRange kRomRangePaletteGroup[ kRomNumThemes ]	= {
																		{ 0x41313,		433,	433,	kRomRangeTypePaletteGroup },		// Ghost Valley
																		{ 0x4117F,		0,		0,		kRomRangeTypePaletteGroup },		// Mario Ciruit
																		{ 0x414C4,		0,		0,		kRomRangeTypePaletteGroup },		// Donut Plains
																		{ 0x419C0,		0,		0,		kRomRangeTypePaletteGroup },		// Choco Island
																		{ 0x4182F,		0,		0,		kRomRangeTypePaletteGroup },		// Vanilla Lake
																		{ 0x41B5B,		0,		0,		kRomRangeTypePaletteGroup },		// Koopa Beach
																		{ 0x41675,		0,		0,		kRomRangeTypePaletteGroup },		// Bowser Castle
																		{ 0x41D0B,		0,		0,		kRomRangeTypePaletteGroup },		// Rainbow Road
																};

// Common Tile Offset 

static const RomRange kRomRangeTileCommon						=		{ 0x40000,		1428,	1248,	kRomRangeTypeCompressedData };

// Theme Tile Offset 

static const RomRange kRomRangeTileset[ kRomNumThemes ]			= {
																		{ 0x60189,		921,	921,	kRomRangeTypeCompressedData },
																		{ 0x481C9,		3489,	3489,	kRomRangeTypeCompressedData },
																		{ 0x50000,		3141,	3141,	kRomRangeTypeCompressedData },
																		{ 0x78000,		2667,	2667,	kRomRangeTypeCompressedData },
																		{ 0x014EE,		2654,	2654,	kRomRangeTypeCompressedData },
																		{ 0x51636,		2445,	2445,	kRomRangeTypeCompressedData },
																		{ 0x48F6A,		3250,	3250,	kRomRangeTypeCompressedData },
																		{ 0x41EBB,		276,	276,	kRomRangeTypeCompressedData },
																};

// Tracks

static const RomRange kRomRangeTracks[ kRomNumTracks ]			= {
																		{ 0x68000,		3372,	3372,	kRomRangeTypeTrack },
																		{ 0x7E821,		1306,	1306,	kRomRangeTypeTrack },
																		{ 0x6A823,		5957,	5957,	kRomRangeTypeTrack },
																		{ 0x7C527,		4312,	4312,	kRomRangeTypeTrack },
																		{ 0x6BF68,		41880,	4188,	kRomRangeTypeTrack },
																		{ 0x3EAD1,		1326,	1326,	kRomRangeTypeTrack },
																		{ 0x3D551,		5504,	5504,	kRomRangeTypeTrack },
																		{ 0x68D2C,		2047,	2047,	kRomRangeTypeTrack },
																		{ 0x6A245,		1502,	1502,	kRomRangeTypeTrack },
																		{ 0x7D5FF,		4642,	4642,	kRomRangeTypeTrack },
																		{ 0x6CFC4,		4586,	4586,	kRomRangeTypeTrack },
																		{ 0x78A6B,		5910,	5910,	kRomRangeTypeTrack },
																		{ 0x3103C,		3907,	3907,	kRomRangeTypeTrack },
																		{ 0x6E1AE,		4484,	4484,	kRomRangeTypeTrack },
																		{ 0x6952B,		3354,	3354,	kRomRangeTypeTrack },
																		{ 0x50C45,		2545,	2545,	kRomRangeTypeTrack },
																		{ 0x6F5BF,		1204,	1204,	kRomRangeTypeTrack },
																		{ 0x7B825,		3330,	3330,	kRomRangeTypeTrack },
																		{ 0x77251,		3501,	3501,	kRomRangeTypeTrack },
																		{ 0x7A181,		5796,	5796,	kRomRangeTypeTrack },
																		{ 0x214EE,		631,	631,	kRomRangeTypeTrack },
																		{ 0x7ED3B,		1106,	1106,	kRomRangeTypeTrack },
																		{ 0x6F338,		647,	647,	kRomRangeTypeTrack },
																		{ 0x21765,		798,	798,	kRomRangeTypeTrack },
																};

@implementation RomEUR

-(void)dealloc
{
	[super dealloc];
}

-(NSDictionary*)offsetDictionary
{
	NSMutableDictionary *dictionary	= [NSMutableDictionary dictionaryWithObjectsAndKeys:
	
		// Rom Header
	
		[NSValue valueWithRomRange:kRomRangeTitle],							[NSNumber numberWithUnsignedInt:kRomHandleTitle],
		[NSValue valueWithRomRange:kRomRangeCartridgeTypeOffset],			[NSNumber numberWithUnsignedInt:kRomHandleCartridgeTypeOffset],
		[NSValue valueWithRomRange:kRomRangeRomSizeOffset],					[NSNumber numberWithUnsignedInt:kRomHandleRomSizeOffset],
		[NSValue valueWithRomRange:kRomRangeRamSizeOffset],					[NSNumber numberWithUnsignedInt:kRomHandleRamSizeOffset],
		[NSValue valueWithRomRange:kRomRangeDestinationCodeOffset],			[NSNumber numberWithUnsignedInt:kRomHandleDestinationCodeOffset],
		[NSValue valueWithRomRange:kRomRangeMaskRomVerOffset],				[NSNumber numberWithUnsignedInt:kRomHandleMaskRomVerOffset],
		[NSValue valueWithRomRange:kRomRangeComplementCheckLowOffset],		[NSNumber numberWithUnsignedInt:kRomHandleComplementCheckLowOffset],
		[NSValue valueWithRomRange:kRomRangeComplementCheckHighOffset],		[NSNumber numberWithUnsignedInt:kRomHandleComplementCheckHighOffset],
		[NSValue valueWithRomRange:kRomRangeChecksumLowOffset],				[NSNumber numberWithUnsignedInt:kRomHandleChecksumLowOffset],
		[NSValue valueWithRomRange:kRomRangeChecksumHighOffset],			[NSNumber numberWithUnsignedInt:kRomHandleChecksumHighOffset],
		[NSValue valueWithRomRange:kRomRangeMarkerCode1Offset],				[NSNumber numberWithUnsignedInt:kRomHandleMarkerCode1Offset],
		[NSValue valueWithRomRange:kRomRangeMarkerCode2Offset],				[NSNumber numberWithUnsignedInt:kRomHandleMarkerCode2Offset],
		[NSValue valueWithRomRange:kRomRangeGameCode1Offset],				[NSNumber numberWithUnsignedInt:kRomHandleGameCode1Offset],
		[NSValue valueWithRomRange:kRomRangeGameCode2Offset],				[NSNumber numberWithUnsignedInt:kRomHandleGameCode2Offset],
		[NSValue valueWithRomRange:kRomRangeGameCode3Offset],				[NSNumber numberWithUnsignedInt:kRomHandleGameCode3Offset],
		[NSValue valueWithRomRange:kRomRangeGameCode4Offset],				[NSNumber numberWithUnsignedInt:kRomHandleGameCode4Offset],
		[NSValue valueWithRomRange:kRomRangeExpansionRamSizeOffset],		[NSNumber numberWithUnsignedInt:kRomHandleExpansionRamSizeOffset],
		[NSValue valueWithRomRange:kRomRangeSpecialVersionOffset],			[NSNumber numberWithUnsignedInt:kRomHandleSpecialVersionOffset],
		[NSValue valueWithRomRange:kRomRangeCartridgeTypeSubNumOffset],		[NSNumber numberWithUnsignedInt:kRomHandleCartridgeTypeSubNumOffset],
		
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
		
		[dictionary setObject:[NSValue valueWithRomRange:kRomRangeTextTheme[ eTheme ]] forKey:[NSNumber numberWithUnsignedInt:handleThemeText]];

		// Theme Tilesets
		
		kRomHandle handleThemeTileset		= kRomHandleTilesetGroupGhostValley + eTheme;
		
		[dictionary setObject:[NSValue valueWithRomRange:kRomRangeTileset[ eTheme ]] forKey:[NSNumber numberWithUnsignedInt:handleThemeTileset]];
		
		// Theme Palettes

		kRomHandle handleThemePalette		= kRomHandlePaletteGroupGhostValley + eTheme;

		[dictionary setObject:[NSValue valueWithRomRange:kRomRangePaletteGroup[ eTheme ]] forKey:[NSNumber numberWithUnsignedInt:handleThemePalette]];
	}
	
	// Track handles
	
	for( kRomTrack eTrack = 0; eTrack < kRomNumTracks; ++eTrack )
	{
		kRomHandle handleTrack				= kRomHandleTrackMarioCircuit3 + eTrack;
		
		[dictionary setObject:[NSValue valueWithRomRange:kRomRangeTracks[ eTrack ]] forKey:[NSNumber numberWithUnsignedInt:handleTrack]];
	}

	return( dictionary );
}

@end

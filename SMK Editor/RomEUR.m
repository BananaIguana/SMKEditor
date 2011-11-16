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
																		{ 0x41313,		433,	433,	kRomRangeTypePaletteGroup },
																		{ 0x4117F,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x414C4,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x419C0,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x4182F,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x41B5B,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x41675,		0,		0,		kRomRangeTypePaletteGroup },
																		{ 0x41D0B,		0,		0,		kRomRangeTypePaletteGroup },
																};

// Common Tile Offset 

static const RomRange kRomRangeTileCommon						=		{ 0x40000,		757,	757,	kRomRangeTypeCompressedData };

//

@implementation RomEUR

-(void)dealloc
{
	[romDict release];

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
		kRomHandle handleThemeText			= kRomHandleTextGhostValley + eTheme;
		
		[dictionary setObject:[NSValue valueWithRomRange:kRomRangeTextTheme[ eTheme ]] forKey:[NSNumber numberWithUnsignedInt:handleThemeText]];
		
		kRomHandle handleThemePalette		= kRomHandlePaletteGroupGhostValley + eTheme;

		[dictionary setObject:[NSValue valueWithRomRange:kRomRangePaletteGroup[ eTheme ]] forKey:[NSNumber numberWithUnsignedInt:handleThemePalette]];
	}

	return( dictionary );
}

@end

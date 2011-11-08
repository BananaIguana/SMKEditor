//
//  RomEUR.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomEUR.h"
#import "RomRef.h"
#import "RomRange.h"
#import "RomObjectText.h"
#import "NSValue+Rom.h"

/*
CARTRIDGE TYPE: 5
ROM SIZE: 9
RAM SIZE: 1
DESTINATION CODE: 2
MASK ROM VERSION: 0
COMPLEMENT CHECK LOW: 71
COMPLEMENT CHECK HIGH: -83
CHECKSUM LOW: -72
CHECKSUM HIGH: 82
MARKER CODE 1: 0
MARKER CODE 2: 0
GAME CODE 1: 0
GAME CODE 2: 0
GAME CODE 3: 0
GAME CODE 4: 0
EXPANSION RAM SIZE: 0
SPECIAL VERSION: 0
CARTRIDGE TYPE SUB: 0
*/

// Rom Header

static const RomRange kRomRangeTitle							= { 0xFFC0, 16, 21, kRomRefTypeString };
static const RomRange kRomRangeCartridgeTypeOffset				= { 0xFFD6, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeRomSizeOffset					= { 0xFFD7, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeRamSizeOffset					= { 0xFFD8, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeDestinationCodeOffset			= { 0xFFD9, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeMaskRomVerOffset					= { 0xFFDB, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckLowOffset			= { 0xFFDC, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckHighOffset		= { 0xFFDD, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeChecksumLowOffset				= { 0xFFDE, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeChecksumHighOffset				= { 0xFFDF, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode1Offset				= { 0xFFB0, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode2Offset				= { 0xFFB1, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeGameCode1Offset					= { 0xFFB2, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeGameCode2Offset					= { 0xFFB3, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeGameCode3Offset					= { 0xFFB4, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeGameCode4Offset					= { 0xFFB5, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeExpansionRamSizeOffset			= { 0xFFBD, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeSpecialVersionOffset				= { 0xFFBE, 1, 1, kRomRefTypeUnsignedChar };
static const RomRange kRomRangeCartridgeTypeSubNumOffset		= { 0xFFBF, 1, 1, kRomRefTypeUnsignedChar };

// Rom String

#define kRomOffsetTextMushroomCupOffset			0x1C924
#define kRomOffsetTextMushroomCupSize			12
#define kRomOffsetTextFlowerCupOffset			0x1C931
#define kRomOffsetTextFlowerCupSize				10
#define kRomOffsetTextStarCupOffset				0x1C93C
#define kRomOffsetTextStarCupSize				8
#define kRomOffsetTextSpecialCupOffset			0x1C945
#define kRomOffsetTextSpecialCupSize			11

@implementation RomEUR

-(void)dealloc
{
	[romDict release];

	[super dealloc];
}

+(NSDictionary*)offsetDictionary
{
	NSDictionary *dictionary	= [NSDictionary dictionaryWithObjectsAndKeys:
	
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
		nil];

	return( dictionary );
}

@end

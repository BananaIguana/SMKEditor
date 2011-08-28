//
//  RomEUR.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomEUR.h"
#import "RomRef.h"

#define kRomOffsetTitle							0xFFC0
#define kRomOffsetCartridgeTypeOffset			0xFFD6
#define kRomOffsetRomSizeOffset					0xFFD7
#define kRomOffsetRamSizeOffset					0xFFD8
#define kRomOffsetDestinationCodeOffset			0xFFD9
#define kRomOffsetMaskRomVerOffset				0xFFDB
#define kRomOffsetComplementCheckLowOffset		0xFFDC
#define kRomOffsetComplementCheckHighOffset		0xFFDD
#define kRomOffsetChecksumLowOffset				0xFFDE
#define kRomOffsetChecksumHighOffset			0xFFDF
#define kRomOffsetMarkerCode1Offset				0xFFB0
#define kRomOffsetMarkerCode2Offset				0xFFB1
#define kRomOffsetGameCode1Offset				0xFFB2
#define kRomOffsetGameCode2Offset				0xFFB3
#define kRomOffsetGameCode3Offset				0xFFB4
#define kRomOffsetGameCode4Offset				0xFFB5
#define kRomOffsetExpansionRamSizeOffset		0xFFBD
#define kRomOffsetSpecialVersionOffset			0xFFBE
#define kRomOffsetCartridgeTypeSubNumOffset		0xFFBF

@implementation RomEUR

-(void)dealloc
{
	[romDict release];

	[super dealloc];
}

+(NSDictionary*)offsetDictionary
{
	NSArray *objects			= [NSArray arrayWithObjects:
	
		[RomRef refWithOffset:kRomOffsetTitle						type:kRomRefTypeString			size:16		max:21],
		[RomRef refWithOffset:kRomOffsetCartridgeTypeOffset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetRomSizeOffset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetRamSizeOffset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetDestinationCodeOffset		type:kRomRefTypeUnsignedChar	size:1],	// Check if this is correct
		[RomRef refWithOffset:kRomOffsetMaskRomVerOffset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetComplementCheckLowOffset	type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetComplementCheckHighOffset	type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetChecksumLowOffset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetChecksumHighOffset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetMarkerCode1Offset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetMarkerCode2Offset			type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetGameCode1Offset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetGameCode2Offset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetGameCode3Offset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetGameCode4Offset				type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetExpansionRamSizeOffset		type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetSpecialVersionOffset		type:kRomRefTypeUnsignedChar	size:1],
		[RomRef refWithOffset:kRomOffsetCartridgeTypeSubNumOffset	type:kRomRefTypeUnsignedChar	size:1],
		nil];
		
	NSArray *keys				= [NSArray arrayWithObjects:
	
		[NSNumber numberWithUnsignedInt:kRomOffsetTitle],
		[NSNumber numberWithUnsignedInt:kRomOffsetCartridgeTypeOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetRomSizeOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetRamSizeOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetDestinationCodeOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetMaskRomVerOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetComplementCheckLowOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetComplementCheckHighOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetChecksumLowOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetChecksumHighOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetMarkerCode1Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetMarkerCode2Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetGameCode1Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetGameCode2Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetGameCode3Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetGameCode4Offset],
		[NSNumber numberWithUnsignedInt:kRomOffsetExpansionRamSizeOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetSpecialVersionOffset],
		[NSNumber numberWithUnsignedInt:kRomOffsetCartridgeTypeSubNumOffset],
		nil];

	NSDictionary *dictionary	= [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	return( dictionary );
}

@end

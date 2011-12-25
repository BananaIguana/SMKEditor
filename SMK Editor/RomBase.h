//
//  RomBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomRange.h"

@class RomObjPaletteGroup;
@class RomObjTileGroup;

typedef enum kRomHandle
{
	// Rom Header
	
	kRomHandleTitle,
	kRomHandleCartridgeTypeOffset,
	kRomHandleRomSizeOffset,
	kRomHandleRamSizeOffset,
	kRomHandleDestinationCodeOffset,
	kRomHandleMaskRomVerOffset,
	kRomHandleComplementCheckLowOffset,
	kRomHandleComplementCheckHighOffset,
	kRomHandleChecksumLowOffset,
	kRomHandleChecksumHighOffset,
	kRomHandleMarkerCode1Offset,
	kRomHandleMarkerCode2Offset,
	kRomHandleGameCode1Offset,
	kRomHandleGameCode2Offset,
	kRomHandleGameCode3Offset,
	kRomHandleGameCode4Offset,
	kRomHandleExpansionRamSizeOffset,
	kRomHandleSpecialVersionOffset,
	kRomHandleCartridgeTypeSubNumOffset,
	
	// Cup Strings
	
	kRomHandleTextMushroomCup,
	kRomHandleTextFlowerCup,
	kRomHandleTextStarCup,
	kRomHandleTextSpecialCup,
	
	// Track Strings
	
	kRomHandleTextGhostValley,				// must be sequential with 'kRomTheme'
	kRomHandleTextMarioCircuit,
	kRomHandleTextDohnutPlains,
	kRomHandleTextChocoIsland,
	kRomHandleTextVanillaLake,
	kRomHandleTextKoopaBeach,
	kRomHandleTextBowserCastle,
	kRomHandleTextRainbowRoad,

	kRomHandleTextBattleCourse,
	
	// Palette Groups
	
	kRomHandlePaletteGroupGhostValley,		// must be sequential with 'kRomTheme'
	kRomHandlePaletteGroupMarioCircuit,
	kRomHandlePaletteGroupDonutPlains,
	kRomHandlePaletteGroupChocoIsland,
	kRomHandlePaletteGroupVanillaLake,
	kRomHandlePaletteGroupKoopaBeach,
	kRomHandlePaletteGroupBowserCastle,
	kRomHandlePaletteGroupRainbowRoad,

	//	
	
	kRomHandleDataTileSetCommon,

	// End

	kRomNumHandles,

}kRomHandle;

@interface RomBase : NSObject
{
	NSData				*data;
	NSDictionary		*romDict;
}

@property(nonatomic,retain) NSData				*data;
@property(nonatomic,retain) NSDictionary		*romDict;

-(id)initWithData:(NSData*)romData;

-(NSDictionary*)offsetDictionary;

// Accessors

-(RomRange)romRangeFromKey:(NSNumber*)key;
-(RomRange)romRangeFromHandle:(kRomHandle)handle;
-(NSNumber*)keyFromHandle:(kRomHandle)handle;
-(id)objectFromHandle:(kRomHandle)handle;
-(id)objectFromRange:(RomRange)range;

// Custom

-(RomObjTileGroup*)tileGroupFromHandle:(kRomHandle)handle paletteGroup:(RomObjPaletteGroup*)paletteGroup;

@end

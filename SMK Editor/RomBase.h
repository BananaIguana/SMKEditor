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
@class RomObjTheme;
@class RomObjTrack;
@class RomObjOverlay;
@class RomObjKart;
@class RomObjPalette;
@class RomObjAIData;

typedef enum kRomHandle
{
	// Rom Header
	
	kRomHandleTitle,
	kRomHandleCartridgeTypeOffset,
	kRomHandleRomSizeOffset,
	kRomHandleRamSizeOffset,
	kRomHandleDestinationCodeOffset,
	kRomHandleLicenseeCodeOffset,
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
	
	kRomHandleTextGhostValley,					// must be sequential with 'kRomTheme'
	kRomHandleTextMarioCircuit,
	kRomHandleTextDohnutPlains,
	kRomHandleTextChocoIsland,
	kRomHandleTextVanillaLake,
	kRomHandleTextKoopaBeach,
	kRomHandleTextBowserCastle,
	kRomHandleTextRainbowRoad,

	kRomHandleTextBattleCourse,
	
	// Palette Groups
	
	kRomHandlePaletteGroupGhostValley,			// must be sequential with 'kRomTheme'
	kRomHandlePaletteGroupMarioCircuit,
	kRomHandlePaletteGroupDonutPlains,
	kRomHandlePaletteGroupChocoIsland,
	kRomHandlePaletteGroupVanillaLake,
	kRomHandlePaletteGroupKoopaBeach,
	kRomHandlePaletteGroupBowserCastle,
	kRomHandlePaletteGroupRainbowRoad,

	// Tilesets
	
	kRomHandleDataTileSetCommon,

	// Tileset Groups

	kRomHandleTilesetGroupGhostValley,			// must be sequential with 'kRomTheme'
	kRomHandleTilesetGroupMarioCircuit,
	kRomHandleTilesetGroupDonutPlains,
	kRomHandleTilesetGroupChocoIsland,
	kRomHandleTilesetGroupVanillaLake,
	kRomHandleTilesetGroupKoopaBeach,
	kRomHandleTilesetGroupBowserCastle,
	kRomHandleTilesetGroupRainbowRoad,
	
	// Tracks

	kRomHandleTrackMarioCircuit3,				// must be sequential with 'kRomTrack'
	kRomHandleTrackGhostValley2,
	kRomHandleTrackDohnutPlains2,
	kRomHandleTrackBowserCastle2,
	kRomHandleTrackVanillaLake2,
	kRomHandleTrackRainbowRoad,
	kRomHandleTrackKoopaBeach2,
	kRomHandleTrackMarioCircuit1,
	kRomHandleTrackGhostValley3,
	kRomHandleTrackBowserCastle3,
	kRomHandleTrackChocoIsland2,
	kRomHandleTrackDohnutPlains3,
	kRomHandleTrackVanillaLake1,
	kRomHandleTrackKoopaBeach1,
	kRomHandleTrackMarioCircuit4,
	kRomHandleTrackMarioCircuit2,
	kRomHandleTrackGhostValley1,
	kRomHandleTrackBowserCastle1,
	kRomHandleTrackChocoIsland1,
	kRomHandleTrackDohnutPlains1,
	kRomHandleTrackBattleCourse3,
	kRomHandleTrackBattleCourse4,
	kRomHandleTrackBattleCourse1,
	kRomHandleTrackBattleCourse2,
	
	// Track Overlay
	
	kRomHandleOverlayMarioCircuit3,				// must be sequential with 'kRomTrack'
	kRomHandleOverlayGhostValley2,
	kRomHandleOverlayDohnutPlains2,
	kRomHandleOverlayBowserCastle2,
	kRomHandleOverlayVanillaLake2,
	kRomHandleOverlayRainbowRoad,
	kRomHandleOverlayKoopaBeach2,
	kRomHandleOverlayMarioCircuit1,
	kRomHandleOverlayGhostValley3,
	kRomHandleOverlayBowserCastle3,
	kRomHandleOverlayChocoIsland2,
	kRomHandleOverlayDohnutPlains3,
	kRomHandleOverlayVanillaLake1,
	kRomHandleOverlayKoopaBeach1,
	kRomHandleOverlayMarioCircuit4,
	kRomHandleOverlayMarioCircuit2,
	kRomHandleOverlayGhostValley1,
	kRomHandleOverlayBowserCastle1,
	kRomHandleOverlayChocoIsland1,
	kRomHandleOverlayDohnutPlains1,
	kRomHandleOverlayBattleCourse3,
	kRomHandleOverlayBattleCourse4,
	kRomHandleOverlayBattleCourse1,
	kRomHandleOverlayBattleCourse2,

	// AI Data
	
	kRomHandleAIDataMarioCircuit3,				// must be sequential with 'kRomAIZone'
	kRomHandleAIDataGhostValley2,
	kRomHandleAIDataDohnutPlains2,
	kRomHandleAIDataBowserCastle2,
	kRomHandleAIDataVanillaLake2,
	kRomHandleAIDataRainbowRoad,
	kRomHandleAIDataKoopaBeach2,
	kRomHandleAIDataMarioCircuit1,
	kRomHandleAIDataGhostValley3,
	kRomHandleAIDataBowserCastle3,
	kRomHandleAIDataChocoIsland2,
	kRomHandleAIDataDohnutPlains3,
	kRomHandleAIDataVanillaLake1,
	kRomHandleAIDataKoopaBeach1,
	kRomHandleAIDataMarioCircuit4,
	kRomHandleAIDataMarioCircuit2,
	kRomHandleAIDataGhostValley1,
	kRomHandleAIDataBowserCastle1,
	kRomHandleAIDataChocoIsland1,
	kRomHandleAIDataDohnutPlains1,

	// Karts
	
	kRomHandleKartMario,						// must be sequential with 'kRomKart'
	kRomHandleKartBowser,
	kRomHandleKartPrincess,
	kRomHandleKartKong,
	kRomHandleKartYoshi,
	kRomHandleKartLuigi,
	kRomHandleKartKoopa,
	kRomHandleKartToad,

	// End

	kRomNumHandles,

}kRomHandle;

@interface RomBase : NSObject

@property(strong) NSData				*data;
@property(strong) NSDictionary			*romDict;
@property(strong) NSArray				*romTrackThemeMappingArray;

@property(strong) NSArray				*themes;
@property(strong) NSArray				*tracks;
@property(strong) NSArray				*karts;

-(id)initWithData:(NSData*)romData;

-(NSDictionary*)offsetDictionary;

// Accessors

-(RomRange)romRangeFromKey:(NSNumber*)key;
-(RomRange)romRangeFromHandle:(kRomHandle)handle;
-(NSNumber*)keyFromHandle:(kRomHandle)handle;
-(id)objectFromHandle:(kRomHandle)handle;
-(id)objectFromRange:(RomRange)range;

// Custom

-(RomObjTileGroup*)tileGroupFromHandle:(kRomHandle)tileGroupHandle paletteGroup:(RomObjPaletteGroup*)paletteGroup;
-(RomObjTheme*)themeFromHandle:(kRomHandle)tileGroupHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup;
-(RomObjTrack*)trackFromHandle:(kRomHandle)trackHandle trackTheme:(RomObjTheme*)theme trackOverlay:(RomObjOverlay*)overlay;
-(RomObjOverlay*)overlayItemFromHandle:(kRomHandle)overlayItemHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup;
-(RomObjAIData*)aiDataFromHandle:(kRomHandle)aiDataHande;
-(RomObjKart*)kartFromHandle:(kRomHandle)kartHandle palette:(RomObjPalette*)palette;

@end

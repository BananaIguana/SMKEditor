//
//  RomBase.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomBase.h"
#import "RomEUR.h"
#import "RomRange.h"
#import "RomObjText.h"
#import "RomObjTileGroup.h"
#import "RomObjPaletteGroup.h"
#import "RomObjTheme.h"
#import "RomObjTrack.h"
#import "RomObjOverlay.h"
#import "RomObjAIData.h"
#import "RomObjKart.h"
#import "NSValue+Rom.h"

static const RomRange kRomRangeTitle							=		{ 0xFFC0,		16,			21,			kRomRangeTypeString };
static const RomRange kRomRangeCartridgeTypeOffset				=		{ 0xFFD6,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeRomSizeOffset					=		{ 0xFFD7,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeRamSizeOffset					=		{ 0xFFD8,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeDestinationCodeOffset			=		{ 0xFFD9,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeLicenseeCode						=		{ 0xFFDA,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMaskRomVerOffset					=		{ 0xFFDB,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckLowOffset			=		{ 0xFFDC,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeComplementCheckHighOffset		=		{ 0xFFDD,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeChecksumLowOffset				=		{ 0xFFDE,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeChecksumHighOffset				=		{ 0xFFDF,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode1Offset				=		{ 0xFFB0,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeMarkerCode2Offset				=		{ 0xFFB1,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode1Offset					=		{ 0xFFB2,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode2Offset					=		{ 0xFFB3,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode3Offset					=		{ 0xFFB4,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeGameCode4Offset					=		{ 0xFFB5,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeExpansionRamSizeOffset			=		{ 0xFFBD,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeSpecialVersionOffset				=		{ 0xFFBE,		1,			1,			kRomRangeTypeUnsignedChar };
static const RomRange kRomRangeCartridgeTypeSubNumOffset		=		{ 0xFFBF,		1,			1,			kRomRangeTypeUnsignedChar };

static const unsigned int kRomTrackThemeMapping[]	= { 1, 0, 2, 6, 4, 7, 5, 1, 0, 6, 3, 2, 4, 5, 1, 1, 0, 6, 3, 2, 4, 1, 2, 5 };

@implementation RomBase

-(id)initWithData:(NSData*)romData
{
	self = [super init];
	
	if( self )
	{
		self.romDict								= [self offsetDictionary];
		self.data									= romData;
		
		int mappingItems							= ( sizeof( kRomTrackThemeMapping ) / sizeof( int ) );
		
		NSMutableArray *array						= [[NSMutableArray alloc] initWithCapacity:mappingItems];
		
		for( int i = 0; i < mappingItems; ++i )
		{
			NSNumber *num							= @(kRomTrackThemeMapping[ i ]);
		
			[array insertObject:num atIndex:i];
		}
		
		self.romTrackThemeMappingArray				= [NSArray arrayWithArray:array];
	}
	
	return( self );
}

-(id)objectFromRange:(RomRange)range
{
	switch( range.type )
	{
		case kRomRangeTypeString :
			{
				NSRange nsRange						= range.range;
				
				char charStore[ nsRange.length ];
				
				[self.data getBytes:charStore range:nsRange];

				charStore[ nsRange.length ]			= 0;
				
				NSString *string					= [NSString stringWithCString:charStore encoding:NSStringEncodingConversionAllowLossy];
				
				return( string );
			
			}break;
			
		case kRomRangeTypeUnsignedChar :
			{
				unsigned char charValue;
				
				[self.data getBytes:&charValue range:range.range];

				NSNumber *numValue					= @(charValue);
				
				return( numValue );
			
			}break;
			
		case kRomRangeTypeEncodedString :
			{
				RomObjText *text					= [[RomObjText alloc] initWithRomData:self.data range:range];
				
				return( text );
			
			}break;
			
		case kRomRangeTypeTileGroup :
			{
				NSAssert( 0, @"You must call 'tileGroupFromHandle'." );
				
				return( nil );
			
			}break;
			
		case kRomRangeTypePaletteGroup :
			{
				RomObjPaletteGroup *group			= [[RomObjPaletteGroup alloc] initWithRomData:self.data range:range];
				
				return( group );
			
			}break;
			
		case kRomRangeTypeTrack :
			{
				NSAssert( 0, @"You must call 'trackFromHandle'." );
			
				return( nil );
			
			}break;
		
		case kRomRangeTypeAIZone :
		case kRomRangeTypeAITarget :
			{
				NSAssert( 0, @"You must call 'aiDataFromHandle'." );
				
				return( nil );
			
			}break;
		
		case kRomRangeTypeKart :
			{
				NSAssert( 0, @"You must call 'kartFromHandle'." );
				
				return( nil );
			
			}break;
		
		default :
			{
				return( nil );			
			}	
	}
}

-(NSNumber*)keyFromHandle:(kRomHandle)handle
{
	NSNumber *key									= [NSNumber numberWithUnsignedInt:handle];
	
	return( key );
}

-(RomRange)romRangeFromKey:(NSNumber*)key
{
	NSValue *value									= (self.romDict)[key];

	NSAssert( [value isKindOfClass:[NSValue class]], @"Unexpected class type acquired from handle. You may need to customise the acquisition of the object." );
	
	RomRange romRange								= [value romRangeValue];
	
	return( romRange );
}

-(RomRange)romRangeFromHandle:(kRomHandle)handle
{
	NSNumber *key									= [self keyFromHandle:handle];
	
	return( [self romRangeFromKey:key] );	
}

-(id)objectFromHandle:(kRomHandle)handle
{
	RomRange romRange								= [self romRangeFromHandle:handle];
	
	id obj											= [self objectFromRange:romRange];
	
	return( obj );	
}

-(RomObjTileGroup*)tileGroupFromHandle:(kRomHandle)tileGroupHandle paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	RomRange romRange								= [self romRangeFromHandle:tileGroupHandle];
	
	RomObjTileGroup *obj							= [[RomObjTileGroup alloc] initWithRomData:self.data range:romRange paletteGroup:paletteGroup];
	
	return( obj );
}

-(RomObjTheme*)themeFromHandle:(kRomHandle)tileGroupHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	RomRange romRange								= [self romRangeFromHandle:tileGroupHandle];
		
	RomObjTheme *theme								= [[RomObjTheme alloc] initWithRomData:self.data range:romRange commonTileGroup:commonTileGroup paletteGroup:paletteGroup];
	
	theme.themeType									= (kRomTheme)( tileGroupHandle - kRomHandleTilesetGroupGhostValley );
	
	NSAssert( ( ( theme.themeType >= kRomThemeGhostValley ) && ( theme.themeType <= kRomThemeRainbowRoad ) ), @"Invalid theme, check kRomTheme runs sequentially with kRomHandle" );

	return( theme );
}

-(RomObjTrack*)trackFromHandle:(kRomHandle)trackHandle trackTheme:(RomObjTheme*)theme trackOverlay:(RomObjOverlay*)overlay aiData:(RomObjAIData*)aiData
{
	RomRange romRange								= [self romRangeFromHandle:trackHandle];
	
	RomObjTrack *track								= [[RomObjTrack alloc] initWithRomData:self.data range:romRange theme:theme overlay:overlay];
	
	track.trackType									= (kRomTrack)( trackHandle - kRomHandleTrackMarioCircuit3 );
	
	track.aiData									= aiData;

	NSAssert( ( ( track.trackType >= kRomTrackMarioCircuit3 ) && ( track.trackType <= kRomTrackBattleCourse2 ) ), @"Invalid theme, check kRomTrack runs sequentially with kRomHandle" );
	
	return( track );
}

-(RomObjOverlay*)overlayItemFromHandle:(kRomHandle)overlayItemHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup
{
	RomRange romRange								= [self romRangeFromHandle:overlayItemHandle];
	
	RomObjOverlay *overlayItem						= [[RomObjOverlay alloc] initWithRomData:self.data range:romRange tileset:commonTileGroup];
	
	return( overlayItem );
}

-(RomObjAIData*)aiDataFromHandle:(kRomHandle)aiDataHande
{
	NSNumber *key									= [self keyFromHandle:aiDataHande];
	
	NSArray *array									= (self.romDict)[key];
	
	NSAssert( [array isKindOfClass:[NSArray class]], @"Unexpected class type acquired from handle." );
	NSAssert( [array count] == 2, @"Unexpected data quantity in array." );
	
	NSValue *valueAIZone							= array[ 0 ];
	NSValue *valueAITarget							= array[ 1 ];
	
	RomRange rangeAIZone							= [valueAIZone romRangeValue];
	RomRange rangeAITarget							= [valueAITarget romRangeValue];
	
	RomObjAIData *aiData							= [[RomObjAIData alloc] initWithRomData:self.data zoneRange:rangeAIZone targetRange:rangeAITarget];
	
	return( aiData );
}

-(RomObjKart*)kartFromHandle:(kRomHandle)kartHandle palette:(RomObjPalette*)palette
{
	RomRange romRange								= [self romRangeFromHandle:kartHandle];
	
	RomObjKart *kart								= [[RomObjKart alloc] initWithRomData:self.data range:romRange palette:palette];
	
	kart.kartType									= (kRomKart)( kartHandle - kRomHandleKartMario );
	
	NSAssert( ( ( kart.kartType >= kRomKartMario ) && ( kart.kartType <= kRomKartToad ) ), @"Invalid theme, check kRomKart runs sequentially with kRomHandle" );

	return( kart );
}

-(NSDictionary*)offsetDictionary
{
	// Basic common catridge ROM layout.

	NSMutableDictionary *dictionary	= [NSMutableDictionary dictionaryWithObjectsAndKeys:
	
		// Rom Header
	
		[NSValue valueWithRomRange:kRomRangeTitle],							[NSNumber numberWithUnsignedInt:kRomHandleTitle],
		[NSValue valueWithRomRange:kRomRangeCartridgeTypeOffset],			[NSNumber numberWithUnsignedInt:kRomHandleCartridgeTypeOffset],
		[NSValue valueWithRomRange:kRomRangeRomSizeOffset],					[NSNumber numberWithUnsignedInt:kRomHandleRomSizeOffset],
		[NSValue valueWithRomRange:kRomRangeRamSizeOffset],					[NSNumber numberWithUnsignedInt:kRomHandleRamSizeOffset],
		[NSValue valueWithRomRange:kRomRangeDestinationCodeOffset],			[NSNumber numberWithUnsignedInt:kRomHandleDestinationCodeOffset],	// $00, $01, $0d use NTSC. Values in range $02..$0c use PAL. Other values are invalid.
		[NSValue valueWithRomRange:kRomRangeLicenseeCode],					[NSNumber numberWithUnsignedInt:kRomHandleLicenseeCodeOffset],
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

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
#import "RomObjKart.h"
#import "NSValue+Rom.h"

static const unsigned int kRomTrackThemeMapping[]	= { 1, 0, 2, 6, 4, 7, 5, 1, 0, 6, 3, 2, 4, 5, 1, 1, 0, 6, 3, 2, 4, 1, 2, 5 };

@implementation RomBase

@synthesize data;
@synthesize romDict;
@synthesize romTrackThemeMappingArray;

@synthesize themes;
@synthesize tracks;
@synthesize karts;

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
			NSNumber *num							= [NSNumber numberWithUnsignedInt:kRomTrackThemeMapping[ i ]];
		
			[array insertObject:num atIndex:i];
		}
		
		self.romTrackThemeMappingArray				= array;
		
		[array release];
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

				NSNumber *numValue					= [NSNumber numberWithUnsignedChar:charValue];
				
				return( numValue );
			
			}break;
			
		case kRomRangeTypeEncodedString :
			{
				RomObjText *text					= [[[RomObjText alloc] initWithRomData:self.data range:range] autorelease];
				
				return( text );
			
			}break;
			
		case kRomRangeTypeTileGroup :
			{
				NSAssert( 0, @"You must call 'tileGroupFromHandle'." );
				
				return( nil );
			
			}break;
			
		case kRomRangeTypePaletteGroup :
			{
				RomObjPaletteGroup *group			= [[[RomObjPaletteGroup alloc] initWithRomData:self.data range:range] autorelease];
				
				return( group );
			
			}break;
			
		case kRomRangeTypeTrack :
			{
				NSAssert( 0, @"You must call 'trackFromHandle'." );
			
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
	NSValue *value									= [self.romDict objectForKey:key];
	
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
	
	RomObjTileGroup *obj							= [[[RomObjTileGroup alloc] initWithRomData:self.data range:romRange paletteGroup:paletteGroup] autorelease];
	
	return( obj );
}

-(RomObjTheme*)themeFromHandle:(kRomHandle)tileGroupHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	RomRange romRange								= [self romRangeFromHandle:tileGroupHandle];
		
	RomObjTheme *theme								= [[[RomObjTheme alloc] initWithRomData:self.data range:romRange commonTileGroup:commonTileGroup paletteGroup:paletteGroup] autorelease];
	
	return( theme );
}

-(RomObjTrack*)trackFromHandle:(kRomHandle)trackHandle trackTheme:(RomObjTheme*)theme trackOverlay:(RomObjOverlay*)overlay
{
	RomRange romRange								= [self romRangeFromHandle:trackHandle];
	
	RomObjTrack *track								= [[[RomObjTrack alloc] initWithRomData:self.data range:romRange theme:theme overlay:overlay] autorelease];
	
	return( track );
}

-(RomObjOverlay*)overlayItemFromHandle:(kRomHandle)overlayItemHandle commonTileGroup:(RomObjTileGroup*)commonTileGroup
{
	RomRange romRange								= [self romRangeFromHandle:overlayItemHandle];
	
	RomObjOverlay *overlayItem						= [[[RomObjOverlay alloc] initWithRomData:self.data range:romRange tileset:commonTileGroup] autorelease];
	
	return( overlayItem );
}

-(RomObjKart*)kartFromHandle:(kRomHandle)kartHandle palette:(RomObjPalette*)palette
{
	RomRange romRange								= [self romRangeFromHandle:kartHandle];
	
	RomObjKart *kart								= [[[RomObjKart alloc] initWithRomData:self.data range:romRange palette:palette] autorelease];
	
	return( kart );
}

-(void)dealloc
{
	[data release];
	[romDict release];
	[romTrackThemeMappingArray release];
	
	[themes release];
	[tracks release];
	[karts release];

	[super dealloc];
}

-(NSDictionary*)offsetDictionary
{
	NSAssert( 0, @"You must override this function" );
	
	return( nil );
}

@end

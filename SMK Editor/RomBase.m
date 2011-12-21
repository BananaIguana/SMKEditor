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
#import "NSValue+Rom.h"

@implementation RomBase

@synthesize data;
@synthesize romDict;

-(id)initWithData:(NSData*)romData
{
	self = [super init];
	
	if( self )
	{
		self.romDict							= [self offsetDictionary];
		self.data								= romData;
	}
	
	return( self );
}

-(id)objectFromRange:(RomRange)range
{
	switch( range.type )
	{
		case kRomRangeTypeString :
			{
				NSRange nsRange					= range.range;
				
				char charStore[ nsRange.length ];
				
				[self.data getBytes:charStore range:nsRange];

				charStore[ nsRange.length ]		= 0;
				
				NSString *string				= [NSString stringWithCString:charStore encoding:NSStringEncodingConversionAllowLossy];
				
				return( string );
			
			}break;
			
		case kRomRangeTypeUnsignedChar :
			{
				unsigned char charValue;
				
				[self.data getBytes:&charValue range:range.range];

				NSNumber *numValue				= [NSNumber numberWithUnsignedChar:charValue];
				
				return( numValue );
			
			}break;
			
		case kRomRangeTypeEncodedString :
			{
				RomObjText *text				= [[[RomObjText alloc] initWithRomData:self.data range:range] autorelease];
				
				return( text );
			
			}break;
			
		case kRomRangeTypeTileGroup :
			{
				RomObjPaletteGroup *pg			= 
			
				RomObjTileGroup *group			= [[[RomObjTileGroup alloc] initWithRomData:self.data range:range paletteGroup:nil] autorelease];
				
				return( group );			
			
			}break;
			
		case kRomRangeTypePaletteGroup :
			{
				RomObjPaletteGroup *group		= [[[RomObjPaletteGroup alloc] initWithRomData:self.data range:range] autorelease];
				
				return( group );
			
			}break;
		
		default :
			{
				return( nil );			
			}	
	}
}

-(NSNumber*)keyFromHandle:(kRomHandle)handle
{
	NSNumber *key = [NSNumber numberWithUnsignedInt:handle];
	
	return( key );
}

-(RomRange)romRangeFromKey:(NSNumber*)key
{
	NSValue *value			= [self.romDict objectForKey:key];
	
	RomRange romRange		= [value romRangeValue];
	
	return( romRange );
}

-(RomRange)romRangeFromHandle:(kRomHandle)handle
{
	NSNumber *key			= [self keyFromHandle:handle];
	
	return( [self romRangeFromKey:key] );	
}

-(id)objectFromHandle:(kRomHandle)handle
{
	RomRange romRange		= [self romRangeFromHandle:handle];
	
	id obj					= [self objectFromRange:romRange];
	
	return( obj );	
}

-(void)dealloc
{
	[data release];
	[romDict release];

	[super dealloc];
}

-(NSDictionary*)offsetDictionary
{
	NSAssert( 0, @"You must override this function" );
	
	return( nil );
}

@end

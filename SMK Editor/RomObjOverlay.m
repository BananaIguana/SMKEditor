//
//  RomObjOverlay.m
//  SMK Editor
//
//  Created by Ian Sidor on 03/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <math.h>

#import "RomObjOverlay.h"
#import "RomObjTileGroup.h"
#import "RomObjTile.h"

@implementation NSValue (OverlayItem)

+(NSValue*)valueWithOverlayItem:(OverlayItem)overlayItem
{
	NSValue *value = [NSValue valueWithBytes:&overlayItem objCType:@encode(OverlayItem)];

	return( value );
}

-(OverlayItem)overlayItemValue
{
	OverlayItem overlayItem;

	[self getValue:&overlayItem];
	
	return( overlayItem );
}

@end

@implementation RomObjOverlay

-(id)initWithRomData:(NSData*)romData range:(RomRange)range tileset:(RomObjTileGroup*)commonTileset
{
	self = [super init];
	
	if( self )
	{
		self.data						= romData;
		self.dataRange					= range;
		self.tileset					= commonTileset;
		
		[self setup];
	}

	return( self );
}

-(NSValue*)processEntry:(unsigned char[3])entry
{
	OverlayItem item;

	item.tableIndex						= ( entry[ 0 ] & 0x3F );
	item.size							= ( entry[ 0 ] & 0xC0 ) >> 6;
	item.tileX							= ( entry[ 1 ] & 0xFF );
	item.tileY							= ( entry[ 2 ] & 0xFF );
	
	int tileAddr						= ( item.tileX ) | ( item.tileY << 8 );
			
	item.tileX							= tileAddr % 128;
	item.tileY							= tileAddr / 128;
	
	NSValue *value						= [NSValue valueWithOverlayItem:item];
	
	return( value );
}

-(void)setup
{	
	div_t divisibleByThree = div( (int)self.dataRange.range.length, 3 );
	
	NSAssert( divisibleByThree.rem == 0, @"Data range must be divisible by three." );
	
	int i								= 0;
	
	NSMutableArray *array				= [NSMutableArray array];
	
	while( i < self.dataRange.range.length )
	{
		unsigned char triByte[ 3 ];
		
		NSRange range					= NSMakeRange( self.dataRange.range.location + i, 3 );
		
		[self.data getBytes:triByte range:range];
		
		NSValue *value					= [self processEntry:triByte];
		
		[array addObject:value];
	
		i								+= 3;
	}
	
	self.overlayItems					= array;
}

-(void)drawTile:(RomObjTile*)tile atX:(int)x y:(int)y
{
	NSPoint point						= NSMakePoint( x, 1016.0 - y );
	
	NSRect rect							= NSMakeRect( 0.0, 0.0, 8.0, 8.0 );

	[tile.image drawAtPoint:point fromRect:rect operation:NSCompositeSourceOver fraction:1.0];
}

-(void)draw22:(OverlayItem*)item startIndex:(int)startIndex
{
	NSArray *tilesetBuffer				= self.tileset.tilesetBuffer;
	
	RomObjTile *tl						= tilesetBuffer[( startIndex + 0 )];
	RomObjTile *tr						= tilesetBuffer[( startIndex + 1 )];
	RomObjTile *bl						= tilesetBuffer[( startIndex + 2 )];
	RomObjTile *br						= tilesetBuffer[( startIndex + 3 )];

	[self drawTile:tl atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tr atX:( ( item->tileX + 1 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:bl atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 1 ) * 8 )];
	[self drawTile:br atX:( ( item->tileX + 1 ) * 8 ) y:( ( item->tileY + 1 ) * 8 )];
}

-(void)draw31:(OverlayItem*)item startIndex:(int)startIndex
{
	NSArray *tilesetBuffer				= self.tileset.tilesetBuffer;

	RomObjTile *l						= tilesetBuffer[( startIndex + 0 )];
	RomObjTile *m						= tilesetBuffer[( startIndex + 1 )];
	RomObjTile *r						= tilesetBuffer[( startIndex + 2 )];

	[self drawTile:l atX:( ( item->tileX + 0 ) * 8 ) y:( item->tileY * 8 )];
	[self drawTile:m atX:( ( item->tileX + 1 ) * 8 ) y:( item->tileY * 8 )];
	[self drawTile:r atX:( ( item->tileX + 2 ) * 8 ) y:( item->tileY * 8 )];
}

-(void)draw13:(OverlayItem*)item startIndex:(int)startIndex
{
	NSArray *tilesetBuffer				= self.tileset.tilesetBuffer;

	RomObjTile *t						= tilesetBuffer[( startIndex + 0 )];
	RomObjTile *m						= tilesetBuffer[( startIndex + 1 )];
	RomObjTile *b						= tilesetBuffer[( startIndex + 2 )];

	[self drawTile:t atX:( item->tileX * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:m atX:( item->tileX * 8 ) y:( ( item->tileY + 1 ) * 8 )];
	[self drawTile:b atX:( item->tileX * 8 ) y:( ( item->tileY + 2 ) * 8 )];
}

-(void)draw55Plus:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
}
	
-(void)draw55Cross:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
}
	
-(void)draw55Slash:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
}
	
-(void)draw55Backslash:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
}

-(void)draw55Horizontal:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 0 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 4 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
}

-(void)draw55Vertical:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 0 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 2 ) * 8 )];
	[self drawTile:tile atX:( ( item->tileX + 2 ) * 8 ) y:( ( item->tileY + 4 ) * 8 )];
}

-(void)drawSingle:(OverlayItem*)item startIndex:(int)startIndex
{
	RomObjTile *tile					= (self.tileset.tilesetBuffer)[startIndex];

	[self drawTile:tile atX:( item->tileX * 8 ) y:( item->tileY * 8 )];
}

-(void)draw:(NSRect)rect
{
	[self.overlayItems enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){
	
		OverlayItem item				= [obj overlayItemValue];
		
		switch( item.tableIndex )
		{
			case 0 :	{		[self draw22:&item startIndex:0];				}break;				
			case 1 :	{		[self draw22:&item startIndex:4];				}break;
			case 2 :	{		[self draw22:&item startIndex:8];				}break;
			case 3 :	{		[self draw22:&item startIndex:12];				}break;
			case 8 :	{		[self draw22:&item startIndex:32];				}break;
			case 9 :	{		[self draw22:&item startIndex:36];				}break;
			case 10 :	{		[self draw22:&item startIndex:40];				}break;
			case 11 :	{		[self draw22:&item startIndex:44];				}break;
			case 12 :
			case 13 :
			case 14 :
			case 15 :	{		[self draw22:&item startIndex:48];				}break;
			case 16 :
			case 17 :
			case 18 :
			case 19 :	{		[self draw22:&item startIndex:58];				}break;			// Oil slick
			case 20 :
			case 21 :
			case 22 :
			case 23 :	{		[self draw31:&item startIndex:52];				}break;
			case 24 :
			case 25 :
			case 26 :
			case 27 :	{		[self draw13:&item startIndex:55];				}break;
			case 28 :
			case 29 :
			case 30 :
			case 31 :	{		[self draw55Plus:&item startIndex:62];			}break;
			case 32 :	
			case 33 :
			case 34 :
			case 35 :	{		[self draw55Cross:&item startIndex:62];			}break;
			case 36 :
			case 37 :
			case 38 :
			case 39 :	{		[self draw55Slash:&item startIndex:62];			}break;
			case 40 :
			case 41 :
			case 42 :
			case 43 :	{		[self draw55Backslash:&item startIndex:62];		}break;
			case 44 :
			case 45 :
			case 46 :	{		[self draw55Horizontal:&item startIndex:62];		}break;
			case 47 :
			case 48 :
			case 49 :	{		[self draw55Vertical:&item startIndex:62];		}break;
			case 52 :	{		[self drawSingle:&item startIndex:62];			}break;
			
			default:
				{
				}
		}
	}];
}

@end

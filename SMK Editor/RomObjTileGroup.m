//
//  RomObjTileGroup.m
//  SMK Editor
//
//  Created by Ian Sidor on 09/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjTileGroup.h"
#import "RomObjTile.h"
#import "RomObjPaletteGroup.h"
#import "RomObjPalette.h"
#import "NSData+Decompressor.h"

static const NSInteger kGroupSize			= 32;

@interface RomObjTileGroup ()
-(void)createPaletteIndices:(unsigned char*)buffer;
-(void)createTileset:(NSData*)data;
@end

@implementation RomObjTileGroup

@synthesize indexBuffer;
@synthesize paletteGroup					= _paletteGroup;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	self = [super initWithRomData:romData range:range];
	
	if( self )
	{
		self.data							= romData;
		self.dataRange						= range;
		self.paletteGroup					= paletteGroup;
		
		[self setup];
	}

	return( self );
}

-(void)setup
{
	NSData *decompressedData				= [self.data decompressRange:self.dataRange.range];
	
	NSUInteger tilesetLength				= decompressedData.length - 0x100;
	
	unsigned char bufferPalette[ 0x100 ], bufferTileset[ tilesetLength ];

	[decompressedData getBytes:bufferPalette length:0x100];
	[decompressedData getBytes:bufferTileset range:NSMakeRange( 0x100, tilesetLength )];
	
	NSData *tilesetData						= [NSData dataWithBytes:bufferTileset length:tilesetLength];
	
	[self createPaletteIndices:bufferPalette];
	[self createTileset:tilesetData];
}

-(void)createPaletteIndices:(unsigned char*)buffer
{
	NSMutableArray *indexArray = [[NSMutableArray alloc] initWithCapacity:0x100];
	
	for( int i = 0; i < 0x100; i++ )
	{
		unsigned char currentIndex			= ( buffer[ i ] >> 4 ) & 0xFF;
		
		NSNumber *index						= [NSNumber numberWithUnsignedChar:currentIndex];
		
		[indexArray addObject:index];
	}

	self.indexBuffer = indexArray;

	[indexArray release];
}

-(void)createTileset:(NSData*)tilesetData
{
	NSUInteger numberOfTiles				= tilesetData.length / kGroupSize;
	
	for( NSUInteger i = 0; i < numberOfTiles; ++i )
	{
		RomRange range						= RomRangeMake( kRomRangeTypeTile, i * kGroupSize, kGroupSize );
	
		NSNumber *paletteIndex				= [self.indexBuffer objectAtIndex:i];
		RomObjPalette *palette				= [self.paletteGroup.paletteArray objectAtIndex:[paletteIndex intValue]];
	
		RomObjTile *tile					= [[RomObjTile alloc] initWithRomData:tilesetData range:range];

		tile.palette						= palette;
	}
}

-(void)dealloc
{
	[indexBuffer release];
	[_paletteGroup release];

	[super dealloc];
}

@end

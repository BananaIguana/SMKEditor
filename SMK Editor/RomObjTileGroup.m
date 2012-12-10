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

-(id)initWithRomData:(NSData*)romData range:(RomRange)range paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	self = [super init];
	
	if( self )
	{
		self.data							= romData;
		self.dataRange						= range;
		self.paletteGroup					= paletteGroup;
		
#if 0 // Temporary fix for theaded processing - I don't understand why setup has to be called on the main thread.
		[self setup];
#else
		[self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
#endif
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
		
		NSNumber *index						= @(currentIndex);
		
		[indexArray addObject:index];
	}

	self.indexBuffer = indexArray;
}

-(void)createTileset:(NSData*)tilesetData
{
	NSUInteger numberOfTiles				= tilesetData.length / kGroupSize;
	
	NSMutableArray *tilesetArray			= [[NSMutableArray alloc] initWithCapacity:numberOfTiles];
	
	for( NSUInteger i = 0; i < numberOfTiles; ++i )
	{
		RomRange range						= RomRangeMake( kRomRangeTypeTile, i * kGroupSize, kGroupSize );
	
		NSNumber *paletteIndex				= (self.indexBuffer)[i];
		RomObjPalette *palette				= (self.paletteGroup.paletteArray)[[paletteIndex intValue]];
	
		RomObjTile *tile					= [[RomObjTile alloc] initWithRomData:tilesetData range:range palette:palette];
		
		[tilesetArray addObject:tile];
				
	}
	
	self.tilesetBuffer						= tilesetArray;	
}

@end

//
//  RomObjPaletteGroup.m
//  SMK Editor
//
//  Created by Ian Sidor on 12/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjPaletteGroup.h"
#import "RomObjPalette.h"
#import "NSData+Decompressor.h"

@implementation RomObjPaletteGroup

// 16 palettes per palette group

#define NSDATA_DECOMPRESSOR_BUFFER_MAX						0x40000

#define NSDATA_DECOMPRESSOR_COMMAND_NO_COMPRESSION			0		// Simple range copy, no compression
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE				1		// Read single source byte, copy to destination for range.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_DOUBLE				2		// Read two source bytes, copy to destination for range.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE_INC			3		// Read single source byte, copy to destination for range, incrementing source after each write
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET				4		// Read short (2 bytes) and recopy to destination from that offset.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_XOR			5		// Read short (2 bytes) and recopy with XOR to destination from that offset.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_DEST		6		// Read byte, subtract from destination and duplicate from that point.
#define NSDATA_DECOMPRESSOR_COMMAND_EXTEND					7		// Extend the byte count.

-(void)setup
{
	NSData *decompressedData		= [self.data decompressRange:self.dataRange.range];
	
	// A single palette is 32 bytes, 16 colours @ 2 bytes per colour. There are 16 palettes
	// per group which means the decompressed range should be: 16 * 32 = 512 bytes.
	
	NSAssert( decompressedData.length == 512, @"Unexpected size of palette group." );
	
	unsigned char paletteBuffer[ 512 ];
	
	[decompressedData getBytes:paletteBuffer];
	
	NSMutableArray *array			= [[NSMutableArray alloc] initWithCapacity:16];

	for( int i = 0; i < 16; ++i )
	{
		RomRange range;
		
		range.type					= kRomRangeTypePalette;
		range.max					= 32;
		range.range					= NSMakeRange( i * 32, 32 );
	
		RomObjPalette *palette		= [[RomObjPalette alloc] initWithRomData:decompressedData range:range];
		
		[array addObject:palette];
	}
	
	self.paletteArray				= array;
}

-(NSString*)description
{
	NSMutableString *desc			= [NSMutableString stringWithFormat:@"Palette Group 0x%08X", (int)self];
	
	[self.paletteArray enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){
	
		NSAssert( [obj class] == [RomObjPalette class], @"Unexpected type." );
		
		RomObjPalette *palette		= (RomObjPalette*)obj;
		
		[desc appendFormat:@"\n--> Palette Index %02lu : %@", idx, palette];
	}];
	
	return( desc );
}


@end

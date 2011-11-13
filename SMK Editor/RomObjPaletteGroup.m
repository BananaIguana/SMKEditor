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

@synthesize palette;

-(void)setup
{
	NSData *decompressedData		= [self.data decompressRange:self.dataRange.range];
	
	// A single palette is 32 bytes, 16 colours @ 2 bytes per colour. There are 16 palettes
	// per group which means the decompressed range should be: 16 * 32 = 512 bytes.
	
	NSAssert( decompressedData.length == 512, @"Unexpected size of palette group." );
	
	char paletteBuffer[ 512 ];
	
	[decompressedData getBytes:paletteBuffer];

	for( int i = 0; i < 16; ++i )
	{
	}
}

-(void)dealloc
{
	[palette release];

	[super dealloc];
}

@end

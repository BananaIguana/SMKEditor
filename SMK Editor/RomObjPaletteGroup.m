//
//  RomObjPaletteGroup.m
//  SMK Editor
//
//  Created by Ian Sidor on 12/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjPaletteGroup.h"
#import "NSData+Decompressor.h"

@implementation RomObjPaletteGroup

// 16 palettes per palette group

-(void)setup
{
	NSData *decompressedData		= [self.data decompressRange:self.dataRange.range];
	
	// A single palette is 32 bytes, 16 colours @ 2 bytes per colour. There are 16 palettes
	// per group which means the decompressed range should be: 16 * 32 = 512 bytes.
	
	NSAssert( decompressedData.length == 512, @"Unexpected size of palette group." );
}

@end

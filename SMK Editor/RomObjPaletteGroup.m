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

@synthesize paletteArray;

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
		
		[palette release];
	}
	
	self.paletteArray				= array;
	
	[array release];
}

-(NSString*)description
{
	NSMutableString *desc			= [NSMutableString stringWithFormat:@"Palette Group 0x%08X", self];
	
	[self.paletteArray enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){
	
		NSAssert( [obj class] == [RomObjPalette class], @"Unexpected type." );
		
		RomObjPalette *palette		= (RomObjPalette*)obj;
		
		[desc appendFormat:@"\n--> Palette Index %02u : %@", idx, palette];
	}];
	
	return( desc );
}

-(void)dealloc
{
	[paletteArray release];

	[super dealloc];
}

@end

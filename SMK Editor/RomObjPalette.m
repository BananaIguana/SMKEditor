//
//  RomObjPalette.m
//  SMK Editor
//
//  Created by Ian Sidor on 12/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjPalette.h"

// 16 colours per palette

@implementation RomObjPalette

@synthesize colour;

-(NSColor*)colourFromData:(unsigned char[2])twoBytes
{
	unsigned int lobyte			= twoBytes[ 0 ];
	unsigned int hibyte			= twoBytes[ 1 ];

	unsigned char nR			= ( ( lobyte & 0x1F ) << 3 ) & 0xFF;
	unsigned char nG			= ( ( ( ( hibyte & 0x03 ) << 3 ) + ( ( lobyte & 0xE0 ) >> 5 ) ) << 3 ) & 0xFF;
	unsigned char nB			= ( ( hibyte & 0x7C ) << 1 ) & 0xFF;
	
	float fR					= (float)nR / 255.0f;
	float fG					= (float)nG / 255.0f;
	float fB					= (float)nB / 255.0f;

	NSColor *colourFromData		= [NSColor colorWithDeviceRed:fR green:fG blue:fB alpha:1.0f];

	return( colourFromData );
}

-(void)setup
{
	NSRange range				= self.dataRange.range;
	
	NSAssert( range.length == 32, @"Function expects 32 byte data range." );
	
	NSMutableArray *paletteColourArray = [NSMutableArray arrayWithCapacity:16];
	
	char		buffer[ 2 ];	
	NSRange		sourceRange;
	
	for( int i = 0; i < 16; ++i )
	{
		sourceRange				= NSMakeRange( i * 2, 2 );
	
		[self.data getBytes:buffer range:sourceRange];				
	}
	
	self.colour					= paletteColourArray;

	[paletteColourArray release];	
}

@end

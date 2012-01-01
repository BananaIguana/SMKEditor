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
	
	NSMutableArray *paletteColourArray = [[NSMutableArray alloc] initWithCapacity:16];
	
	unsigned char buffer[ 2 ];	
	NSRange sourceRange;

	for( int i = 0; i < 16; ++i )
	{
		sourceRange				= NSMakeRange( self.dataRange.range.location + ( i * 2 ), 2 );
	
		[self.data getBytes:buffer range:sourceRange];
				
		NSColor *col			= [self colourFromData:buffer];
		
		[paletteColourArray addObject:col];
	}
	
	self.colour					= paletteColourArray;

	[paletteColourArray release];	
}

-(NSString*)description
{
	NSMutableString *desc		= [NSMutableString stringWithFormat:@"Palette 0x%08X", self];
	
	[self.colour enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){
	
		NSAssert( [obj isKindOfClass:[NSColor class]], @"Unexpected type." );
		
		NSColor *col			= (NSColor*)obj;

		[desc appendFormat:@"\n--> Colour Index %02u : R-%03d G-%03d B-%03d A-%03d",
		
			idx,
			(int)( [col redComponent]		* 255.0f ),
			(int)( [col greenComponent]		* 255.0f ),
			(int)( [col blueComponent]		* 255.0f ),
			(int)( [col alphaComponent]		* 255.0f )];		
	}];
	
	return( desc );
}

-(void)dealloc
{
	[colour release];

	[super dealloc];
}

@end

//
//  RomObjKart.m
//  SMK Editor
//
//  Created by Ian Sidor on 06/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObjKart.h"
#import "RomObjPalette.h"

@implementation RomObjKart

-(id)initWithRomData:(NSData*)romData range:(RomRange)range palette:(RomObjPalette*)palette
{
	self = [super init];
	
	if( self )
	{
		self.data									= romData;
		self.dataRange								= range;
		self.palette								= palette;
		self.kartType								= kRomNumKarts;		// Initialise as invalid.
		
		[self setup];
	}

	return( self );
}

+(unsigned short int)processBitplaneForMask:(unsigned int)mask shift:(unsigned int)shift plane1:(unsigned char)p1 plane2:(unsigned char)p2 plane3:(unsigned char)p3 plane4:(unsigned char)p4
{
	unsigned short int ret							=	( ( ( p1 & mask ) >> shift ) << 0 ) |
														( ( ( p2 & mask ) >> shift ) << 1 ) |
														( ( ( p3 & mask ) >> shift ) << 2 ) |
														( ( ( p4 & mask ) >> shift ) << 3 );
											
	return( ret );
}

-(NSImage*)imageFromTileData:(NSData*)tileData
{
	NSBitmapImageRep *bitmap						= [[NSBitmapImageRep alloc]
	
		initWithBitmapDataPlanes:nil
		pixelsWide:8
		pixelsHigh:8
		bitsPerSample:8
		samplesPerPixel:4
		hasAlpha:YES
		isPlanar:NO
		colorSpaceName:NSDeviceRGBColorSpace
		bytesPerRow:(8 * 4)
		bitsPerPixel:32];

	NSRange range									= NSMakeRange( 0, sizeof( unsigned int ) * 8 );

	for( int y = 0; y < 8; y++ )
	{	
		unsigned int bytes[ 8 ];
		
		range.location								= y * sizeof( unsigned int ) * 8;

		[tileData getBytes:bytes range:range];

		for( int x = 0; x < 8; x++ )
		{
			NSUInteger bitmapColour[ 4 ];
			
			NSUInteger index						= (NSUInteger)bytes[ x ];	
			
			index									%= [self.palette.colour count];
			
			NSColor *paletteColour					= (self.palette.colour)[index];
				
			CGFloat red								= [paletteColour redComponent]; 
			CGFloat green							= [paletteColour greenComponent]; 
			CGFloat blue							= [paletteColour blueComponent]; 

			bitmapColour[ 0 ]						= (NSUInteger)( red * 255.0f );
			bitmapColour[ 1 ]						= (NSUInteger)( green * 255.0f );
			bitmapColour[ 2 ]						= (NSUInteger)( blue * 255.0f );
			bitmapColour[ 3 ]						= 255;

			[bitmap setPixel:bitmapColour atX:x y:y];
		}
	}

	CGImageRef ref									= [bitmap CGImage];

	NSImage *im										= [[NSImage alloc] initWithCGImage:ref size:NSMakeSize( 8, 8 )];
	
	return( im );	
}

//		Bytes

//		0		1		2		3		4		5		6		7
//		8		9		10		11		12		13		14		15
//		16		17		18		19		20		21		22		23
//		24		25		26		27		28		29		30		31

//		Pixels
//
//						col 1							col 2
//
//	row 1		[0, 1, 16,17] & 0x80			[0, 1, 16,17] & 0x40		.. etc
//	row 2		[2, 3, 18,19] & 0x80			[2, 3, 18,19] & 0x40
//	row 3		[4, 5, 20,21] & 0x80			[4, 5, 20,21] & 0x40
//	row 4		[6, 7, 22,23] & 0x80			[6, 7, 22,23] & 0x40
//	row 5		[8, 9, 24,25] & 0x80			[8, 9, 24,25] & 0x40
//	row 6		[10,11,26,27] & 0x80			[10,11,26,27] & 0x40
//	row 7		[12,13,28,29] & 0x80			[12,13,28,29] & 0x40
//	row 8		[14,15,30,31] & 0x80			[14,15,30,31] & 0x40

-(NSData*)processTile:(unsigned char*)tile32bytes
{
	unsigned int columnMask[ 8 ]					= { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
	unsigned int shift[ 8 ]							= { 7, 6, 5, 4, 3, 2, 1, 0 };

	unsigned int indexGrid[ 8 ][ 8 ];				// Row Major
	unsigned int offsets[ 8 ][ 4 ]					= {
														{ 0x00, 0x01, 0x10, 0x11 },
														{ 0x02, 0x03, 0x12, 0x13 },
														{ 0x04, 0x05, 0x14, 0x15 },
														{ 0x06, 0x07, 0x16, 0x17 },
														{ 0x08, 0x09, 0x18, 0x19 },
														{ 0x0A, 0x0B, 0x1A, 0x1B },
														{ 0x0C, 0x0D, 0x1C, 0x1D },
														{ 0x0E, 0x0F, 0x1E, 0x1F },
													};

	for( int y = 0; y < 8; ++y )
	{
		for( int x = 0; x < 8; ++x )
		{
			unsigned int m							= columnMask[ x ];

			unsigned int o1							= offsets[ y ][ 0 ];
			unsigned int o2							= offsets[ y ][ 1 ];
			unsigned int o3							= offsets[ y ][ 2 ];
			unsigned int o4							= offsets[ y ][ 3 ];

			unsigned int p1							= tile32bytes[ o1 ];
			unsigned int p2							= tile32bytes[ o2 ];
			unsigned int p3							= tile32bytes[ o3 ];
			unsigned int p4							= tile32bytes[ o4 ];			

			indexGrid[ y ][ x ]						= [RomObjKart processBitplaneForMask:m shift:shift[ x ] plane1:p1 plane2:p2 plane3:p3 plane4:p4];
		}
	}

	NSData *indexData								= [[NSData alloc] initWithBytes:indexGrid length:( sizeof( unsigned int ) * 8 * 8 )];
		
	return( indexData );
}

-(void)setup
{
	int i											= 0;
	NSRange range									= self.dataRange.range;
	
	NSMutableArray *array							= [[NSMutableArray alloc] init];
	
	while( i < range.length )
	{
		unsigned char tile[ 32 ];
		
		[self.data getBytes:tile range:NSMakeRange( i + range.location, 32 )];
		
		NSData *tileData							= [self processTile:tile];
		
		NSImage *image								= [self imageFromTileData:tileData];
		
		[array addObject:image];

		i											+= 32;
	}

	self.imageArray									= array;
}

-(NSString*)description
{
	return( RomKartToString( self.kartType ) );
}

@end

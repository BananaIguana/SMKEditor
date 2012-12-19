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

			bitmapColour[ 0 ]						= (NSUInteger)( red * 255.0 );
			bitmapColour[ 1 ]						= (NSUInteger)( green * 255.0 );
			bitmapColour[ 2 ]						= (NSUInteger)( blue * 255.0 );
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

	self.imageTileArray								= array;
	
	NSMutableArray *ar								= [NSMutableArray array];
	
	for( NSInteger i = 0; i < 5; ++i )
	{
		NSImage *image;

		switch( i )
		{
			case 0 :
				{
					image							= [self processImage24_1:i];
					
					[ar addObject:image];
				
					image							= [self processImage24_2:i];
					
					[ar addObject:image];
				
				}break;
				
			default :
				{
					image							= [self processImage44:i];

					[ar addObject:image];
				}
		}
	}
	
	self.imageArray									= ar;
}

-(NSImage*)flipImageVertically:(NSImage*)srcImage
{
	NSImage *dstImage								= [[NSImage alloc] initWithSize:srcImage.size];

	[dstImage lockFocus];

	NSAffineTransform *transform					= [NSAffineTransform transform];
	
	[transform translateXBy:srcImage.size.width yBy:0.0];
	[transform scaleXBy:-1.0 yBy:1.0];
	
	[transform set];

	NSRect rect										= NSMakeRect( 0.0f, 0.0f, srcImage.size.width, srcImage.size.height );

	[srcImage drawInRect:rect fromRect:rect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];
	
	[dstImage unlockFocus];

	return( dstImage );
}

-(NSImage*)mergeImage:(NSImage*)left withImage:(NSImage*)right
{
	NSSize srcSize									= left.size;
	NSSize dstSize									= NSMakeSize( srcSize.width * 2.0, srcSize.height );
	
	NSImage *dstImage								= [[NSImage alloc] initWithSize:dstSize];
	
	[dstImage lockFocus];

	NSRect srcRect									= NSMakeRect( 0.0f, 0.0f, srcSize.width, srcSize.height );

	[left drawInRect:srcRect fromRect:srcRect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];

	NSRect altRect									= NSMakeRect( srcSize.width, 0.0f, srcSize.width, srcSize.height );

	[right drawInRect:altRect fromRect:srcRect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];
	
	[dstImage unlockFocus];
	
	return( dstImage );
}

-(NSImage*)processImage44:(NSInteger)imageIndex
{
	NSUInteger indices[] = {
	
		( 16 * 3 ) + 0,		( 16 * 2 ) + 0,		( 16 * 1 ) + 0,		( 16 * 0 ) + 0,
		( 16 * 3 ) + 1,		( 16 * 2 ) + 1,		( 16 * 1 ) + 1,		( 16 * 0 ) + 1,
		( 16 * 3 ) + 2,		( 16 * 2 ) + 2,		( 16 * 1 ) + 2,		( 16 * 0 ) + 2,
		( 16 * 3 ) + 3,		( 16 * 2 ) + 3,		( 16 * 1 ) + 3,		( 16 * 0 ) + 3,
	};

	return( [self processImageIndex:imageIndex withOffsetMatrix:indices x:4 y:4] );
}

-(NSImage*)processImage24_1:(NSInteger)imageIndex
{
	NSUInteger indices[] = {
	
		( 16 * 3 ) + 0,		( 16 * 2 ) + 0,
		( 16 * 1 ) + 0,		( 16 * 0 ) + 0,
		( 16 * 3 ) + 1,		( 16 * 2 ) + 1,
		( 16 * 1 ) + 1,		( 16 * 0 ) + 1,		
	};
	
	NSImage *left									= [self processImageIndex:imageIndex withOffsetMatrix:indices x:2 y:4];	
	NSImage *right									= [self flipImageVertically:left];

	return( [self mergeImage:left withImage:right] );
}

-(NSImage*)processImage24_2:(NSInteger)imageIndex
{
	NSUInteger indices[] = {
	
		( 16 * 3 ) + 2,		( 16 * 2 ) + 2,
		( 16 * 1 ) + 2,		( 16 * 0 ) + 2,
		( 16 * 3 ) + 3,		( 16 * 2 ) + 3,
		( 16 * 1 ) + 3,		( 16 * 0 ) + 3,
	};
	
	NSImage *left									= [self processImageIndex:imageIndex withOffsetMatrix:indices x:2 y:4];	
	NSImage *right									= [self flipImageVertically:left];

	return( [self mergeImage:left withImage:right] );
}

-(NSImage*)processImageIndex:(NSInteger)imageIndex withOffsetMatrix:(NSUInteger*)matrix x:(NSUInteger)xLen y:(NSUInteger)yLen
{
	NSBitmapImageRep *bitmap						= [[NSBitmapImageRep alloc]
	
		initWithBitmapDataPlanes:nil
		pixelsWide:( 8 * xLen )
		pixelsHigh:( 8 * yLen )
		bitsPerSample:8
		samplesPerPixel:4
		hasAlpha:YES
		isPlanar:NO
		colorSpaceName:NSDeviceRGBColorSpace
		bytesPerRow:( 8 * xLen * 4 )
		bitsPerPixel:32];
		
	[NSGraphicsContext saveGraphicsState];
	
	NSGraphicsContext *context						= [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
	
	[NSGraphicsContext setCurrentContext:context];

	NSUInteger count								= 0;

	for( int x = 0; x < xLen; ++x )
	{
		for( int y = 0; y < yLen; ++y )
		{
			NSUInteger index						= matrix[ count++ ] + ( 4 * imageIndex );

			NSImage *current						= [self.imageTileArray objectAtIndex:index];
			
			NSRect srcRect							= NSMakeRect( 0.0f, 0.0f, current.size.width, current.size.height );
			
			NSRect rect								= NSMakeRect( x * 8, y * 8	, 8, 8 );
			
			[current drawInRect:rect fromRect:srcRect operation:NSCompositeCopy fraction:1.0f respectFlipped:NO hints:0];
		}
	}
	
	CGImageRef ref									= [bitmap CGImage];

	NSImage *im										= [[NSImage alloc] initWithCGImage:ref size:NSMakeSize( ( 8 * xLen ), ( 8 * yLen ) )];

	[NSGraphicsContext restoreGraphicsState];
	
	return( im );
}

-(NSString*)description
{
	return( RomKartToString( self.kartType ) );
}

@end

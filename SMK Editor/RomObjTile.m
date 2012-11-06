//
//  RomObjTile.m
//  SMK Editor
//
//  Created by Ian Sidor on 19/11/2011.
//  Copyright 2011 Banana Iguana. All rights reserved.
//

#import "RomObjTile.h"
#import "RomObjPalette.h"

@implementation RomObjTile

@synthesize palette = _palette;
@synthesize image;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range palette:(RomObjPalette*)palette
{
	self = [super init];
	
	if( self )
	{
		self.data									= romData;
		self.dataRange								= range;
		self.palette								= palette;
		
		[self setup];
	}	
	
	return( self );
}

-(void)setup
{
	unsigned char buffer[ 32 ];
	
	[self.data getBytes:buffer range:self.dataRange.range];

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

	for( int x = 0; x < 4; x++ )
	{
		for( int y = 0; y < 8; y++ )
		{
			unsigned char pixel1					= ( ( buffer[ x + y * 4 ] & 0x0F ) >> 0 ) & 0xFF;
			unsigned char pixel2					= ( ( buffer[ x + y * 4 ] & 0xF0 ) >> 4 ) & 0xFF;
			
			indexBuffer[ ( x * 2 ) + 0 ][ y ]		= pixel1;
			indexBuffer[ ( x * 2 ) + 1 ][ y ]		= pixel2;			
		}
	}
	
	for( int x = 0; x < 8; x++ )
	{
		for( int y = 0; y < 8; y++ )
		{
			unsigned char index						= indexBuffer[ x ][ y ];
			
			NSColor *paletteColour					= (self.palette.colour)[(NSUInteger)index];
			
			CGFloat red								= [paletteColour redComponent]; 
			CGFloat green							= [paletteColour greenComponent]; 
			CGFloat blue							= [paletteColour blueComponent]; 
			
			NSUInteger bitmapColour[ 4 ];			
			
			bitmapColour[ 0 ]						= (NSUInteger)( red * 255.0f );
			bitmapColour[ 1 ]						= (NSUInteger)( green * 255.0f );
			bitmapColour[ 2 ]						= (NSUInteger)( blue * 255.0f );
			bitmapColour[ 3 ]						= 255;
			
			[bitmap setPixel:bitmapColour atX:x y:y];
		}	
	}

	CGImageRef ref									= [bitmap CGImage];

	NSImage *im										= [[NSImage alloc] initWithCGImage:ref size:NSMakeSize( 8, 8 )];
	
	self.image										= im;
	
	[im release];
	
	[bitmap release];
}

-(void)dealloc
{
	[_palette release];
	[image release];

	[super dealloc];
}

@end

//
//  RomObjTile.m
//  SMK Editor
//
//  Created by Ian Sidor on 19/11/2011.
//  Copyright 2011 Banana Iguana. All rights reserved.
//

#import "RomObjTile.h"

@implementation RomObjTile

@synthesize palette;

-(void)setup
{
	unsigned char buffer[ 48 ];
	
	[self.data getBytes:buffer length:48];

	NSBitmapImageRep *image = [[NSBitmapImageRep alloc]
	
                     initWithBitmapDataPlanes:NULL
                     pixelsWide:8 
                     pixelsHigh:8
                     bitsPerSample:8
                     samplesPerPixel:3
                     hasAlpha:NO
                     isPlanar:NO
                     colorSpaceName:NSDeviceRGBColorSpace
                     bytesPerRow:8
                     bitsPerPixel:8];

	for( int x = 0; x < 4; x++ )
	{
		for( int y = 0; y < 8; y++ )
		{
			NSUInteger nPixel1 = ( ( buffer[ x + y * 4 ] & 0x0F ) >> 0 ) & 0xFF;
			NSUInteger nPixel2 = ( ( buffer[ x + y * 4 ] & 0xF0 ) >> 4 ) & 0xFF;
			
			[image setPixel:&nPixel1 atX:( x * 2 + 0 ) y:y];
			[image setPixel:&nPixel2 atX:( x * 2 + 1 ) y:y];
		}
	}
	
	[image release];
}

-(void)dealloc
{
	[palette release];

	[super dealloc];
}

@end
/*
	private ImageData imageData;
	private Image image;
	
	public RomTile( final RomPalette palette, final byte[] buffer )
	{
		createTile( palette, buffer );	
	}
	
	protected void createTile( final RomPalette palette, final byte[] buffer )
	{
		imageData = new ImageData( 8, 8, 8, palette.getPaletteData() );
				
		for( int x = 0; x < 4; x++ )
		{ 
			for( int y = 0; y < 8; y++ )
			{
				int nPixel1 = ( ( buffer[ x + y * 4 ] & 0x0F ) >> 0 ) & 0xFF;
				int nPixel2 = ( ( buffer[ x + y * 4 ] & 0xF0 ) >> 4 ) & 0xFF;

				imageData.setPixel( x * 2 + 0, y, nPixel1 );
				imageData.setPixel( x * 2 + 1, y, nPixel2 );
			}
		}
		
		image = new Image( Global.display, imageData );
	}
	
	public Image getImage()
	{
		return( image );
	}
	
	public ImageData getImageData()
	{
		return( imageData );	
	}
*/
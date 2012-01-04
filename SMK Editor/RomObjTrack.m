//
//  RomObjTrack.m
//  SMK Editor
//
//  Created by Ian Sidor on 31/12/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjTrack.h"
#import "RomObjTileGroup.h"
#import "RomObjTile.h"
#import "RomObjTheme.h"
#import "RomObjOverlay.h"

#import "NSData+Decompressor.h"

@implementation RomObjTrack

@synthesize theme = _theme;
@synthesize trackData;
@synthesize image;
@synthesize imageBitmap;
@synthesize trackType;
@synthesize overlay;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range theme:(RomObjTheme*)theme overlay:(RomObjOverlay*)trackOverlay
{
	self = [super init];
	
	if( self )
	{
		self.data			= romData;
		self.dataRange		= range;
		self.theme			= theme;
		self.overlay		= trackOverlay;
		
		[self setup];
	}

	return( self );
}

-(void)setup
{
	self.trackData							= [self.data decompressTrackRange:self.dataRange.range];
	
	NSAssert( self.trackData.length == ( 128 * 128 ), @"Unexpected track size decompressed." );
	
	NSBitmapImageRep *bitmap				= [[NSBitmapImageRep alloc]
	
		initWithBitmapDataPlanes:nil
		pixelsWide:1024
		pixelsHigh:1024
		bitsPerSample:8
		samplesPerPixel:4
		hasAlpha:YES
		isPlanar:NO
		colorSpaceName:NSDeviceRGBColorSpace
		bytesPerRow:(1024 * 4)
		bitsPerPixel:32];
		
	RomObjTileGroup *tileGroupCommon		= self.theme.tileGroupCommon;
	RomObjTileGroup *tileGroupTheme			= self.theme;

	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap]];

	int index								= 0;

	for( int y = 0; y < 128; y++ )
	{
		for( int x = 0; x < 128; x++ )
		{
			unsigned char byte;
			NSImage *imageTile;
			
			[self.trackData getBytes:&byte range:NSMakeRange( index, 1 )];
			
			NSArray *buffer;
			
			if( byte < 192 )
			{
				buffer						= tileGroupTheme.tilesetBuffer;
			}
			else
			{
				buffer						= tileGroupCommon.tilesetBuffer;
			}
			
			byte							%= [buffer count];

			RomObjTile *tile				= [buffer objectAtIndex:byte];
			imageTile						= tile.image;
			
			NSRect dst						= NSMakeRect( x * 8, 1016.0f - ( y * 8 ), 8, 8 );
			NSRect src						= NSMakeRect( 0, 0, 8, 8 );
					
			[imageTile drawInRect:dst fromRect:src operation:NSCompositeCopy fraction:1.0f];

			index++;		
		}	
	}
	
	[NSGraphicsContext restoreGraphicsState];
	
	CGImageRef ref									= [bitmap CGImage];

	NSImage *im										= [[NSImage alloc] initWithCGImage:ref size:NSMakeSize( 1024, 1024 )];
	
	self.image										= im;
	self.imageBitmap								= bitmap;
	
	[im release];
		
	[bitmap release];	
}

-(void)draw:(NSRect)rect
{
	NSRect r = NSMakeRect( 0.0f, 0.0f, 1024.0f, 1024.0f );
	[image drawInRect:r fromRect:r operation:NSCompositeCopy fraction:1.0f];
	
	RomObjOverlay *o								= self.overlay;
	
	[o draw:r];
}

-(NSString*)description
{
	return( RomTrackToString( trackType ) );
}

-(void)dealloc
{
	[_theme release];
	[trackData release];
	[image  release];
	[imageBitmap release];
	[overlay release];

	[super dealloc];
}

@end

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

#import "NSData+Decompressor.h"

@implementation RomObjTrack

@synthesize theme = _theme;
@synthesize trackData;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range theme:(RomObjTheme*)theme
{
	self = [super initWithRomData:romData range:range];
	
	if( self )
	{
		self.theme = theme;
	}
	
	return( self );
}

-(void)setup
{
	self.trackData						= [self.data decompressTrackRange:self.dataRange.range];
	
	NSAssert( self.trackData.length == ( 128 * 128 ), @"Unexpected track size decompressed." );
}

-(void)draw
{
	RomObjTileGroup *tileGroupCommon		= self.theme.tileGroupCommon;
	RomObjTileGroup *tileGroupTheme			= self.theme;

	int index								= 0;

	for( int y = 0; y < 128; y++ )
	{
		for( int x = 0; x < 128; x++ )
		{
			unsigned char byte;
			NSImage *image;
			
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
			image							= tile.image;
			
			NSRect dst						= NSMakeRect( x * 8, y * 8, 8, 8 );
			NSRect src						= NSMakeRect( 0, 0, 8, 8 );
			
			[image drawInRect:dst fromRect:src operation:NSCompositeCopy fraction:1.0f];

			index++;		
		}	
	}
}

-(void)dealloc
{
	[_theme release];
	[trackData release];

	[super dealloc];
}

@end

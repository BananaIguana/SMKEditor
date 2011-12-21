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
}

-(void)dealloc
{
	[palette release];

	[super dealloc];
}

@end

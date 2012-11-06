//
//  RomObjTile.h
//  SMK Editor
//
//  Created by Ian Sidor on 19/11/2011.
//  Copyright 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomObj.h"

@class RomObjPalette;

@interface RomObjTile : RomObj
{
	RomObjPalette			*_palette;
	
	unsigned char			indexBuffer[ 8 ][ 8 ];
	
	NSImage					*image;
}

@property(retain) RomObjPalette		*palette;
@property(retain) NSImage			*image;

-(id)initWithRomData:(NSData *)romData range:(RomRange)range palette:(RomObjPalette*)palette;

@end

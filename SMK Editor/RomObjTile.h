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
	RomObjPalette			*palette;
	
	unsigned char			indexBuffer[ 8 ][ 8 ];
}

@property(nonatomic,retain) RomObjPalette	*palette;

@end

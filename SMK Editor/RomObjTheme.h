//
//  RomObjTheme.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomObjTileGroup.h"

@class RomObjTileGroup;
@class RomObjPaletteGroup;

@interface RomObjTheme : RomObjTileGroup
{
	RomObjTileGroup								*tileGroupCommon;
}

@property(nonatomic,retain) RomObjTileGroup		*tileGroupCommon;

-(id)initWithRomData:(NSData*)tilesetGroupRomData range:(RomRange)range commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup;

@end

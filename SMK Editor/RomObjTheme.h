//
//  RomObjTheme.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomObjTileGroup.h"
#import "RomTypes.h"

@class RomObjTileGroup;
@class RomObjPaletteGroup;

@interface RomObjTheme : RomObjTileGroup

@property(strong) RomObjTileGroup				*tileGroupCommon;
@property(assign) kRomTheme						themeType;

-(id)initWithRomData:(NSData*)tilesetGroupRomData range:(RomRange)range commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup;

@end

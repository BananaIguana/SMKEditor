//
//  RomObjTileGroup.h
//  SMK Editor
//
//  Created by Ian Sidor on 09/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

@class RomObjPaletteGroup;

@interface RomObjTileGroup : RomObj
{
	NSArray					*indexBuffer;
	NSArray					*tilesetBuffer;
	RomObjPaletteGroup		*_paletteGroup;
}

@property(retain) NSArray					*indexBuffer;
@property(retain) NSArray					*tilesetBuffer;
@property(retain) RomObjPaletteGroup		*paletteGroup;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range paletteGroup:(RomObjPaletteGroup*)paletteGroup;

@end

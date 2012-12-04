//
//  RomObjOverlayItem.h
//  SMK Editor
//
//  Created by Ian Sidor on 03/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

@class RomObjTileGroup;

typedef struct OverlayItem
{
	unsigned char tableIndex;
	unsigned char size;
	unsigned char tileX;
	unsigned char tileY;

}OverlayItem;

@interface NSValue (OverlayItem)

+(NSValue*)valueWithOverlayItem:(OverlayItem)range;

-(OverlayItem)overlayItemValue;

@end

@interface RomObjOverlay : RomObj

@property(strong) RomObjTileGroup		*tileset;
@property(strong) NSArray				*overlayItems;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range tileset:(RomObjTileGroup*)commonTileset;
-(void)draw:(NSRect)rect;

@end

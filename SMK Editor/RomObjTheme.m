//
//  RomObjTheme.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "NSData+Decompressor.h"
#import "RomObjTheme.h"

@implementation RomObjTheme

-(id)initWithRomData:(NSData*)tilesetGroupRomData range:(RomRange)range commonTileGroup:(RomObjTileGroup*)commonTileGroup paletteGroup:(RomObjPaletteGroup*)paletteGroup
{
	self = [super initWithRomData:tilesetGroupRomData range:range paletteGroup:paletteGroup];
	
	if( self )
	{
		self.tileGroupCommon = commonTileGroup;	
	}
	
	return( self );
}

@end

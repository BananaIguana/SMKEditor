//
//  RomObjTileGroup.m
//  SMK Editor
//
//  Created by Ian Sidor on 09/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjTileGroup.h"
#import "NSData+Decompressor.h"

@implementation RomObjTileGroup

-(void)setup
{
	NSData *decompressedData		= [self.data decompressRange:self.dataRange.range];
	
	NSLog( @"Data = %@", decompressedData );
}

@end

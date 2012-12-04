//
//  RomObjKart.h
//  SMK Editor
//
//  Created by Ian Sidor on 06/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

// Ref	:	http://smwc.hostzi.com/SMWiki/wiki/SNES_4BPP_file_format.html
// 		:	http://mrclick.zophar.net/TilEd/download/consolegfx.txt
//		:	http://wiki.superfamicom.org/snes/show/SNES+Sprites

@class RomObjPalette;

@interface RomObjKart : RomObj

@property(strong) RomObjPalette		*palette;
@property(strong) NSArray			*imageArray;

-(id)initWithRomData:(NSData *)romData range:(RomRange)range palette:(RomObjPalette*)palette;

@end

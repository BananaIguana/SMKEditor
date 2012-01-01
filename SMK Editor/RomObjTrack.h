//
//  RomObjTrack.h
//  SMK Editor
//
//  Created by Ian Sidor on 31/12/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

@class RomObjTheme;

@interface RomObjTrack : RomObj
{
	RomObjTheme		*_theme;
	NSData			*trackData;
}

@property(nonatomic,retain) RomObjTheme		*theme;
@property(nonatomic,retain) NSData			*trackData;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range theme:(RomObjTheme*)theme;
-(void)draw;

@end

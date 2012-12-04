//
//  RomObjTrack.h
//  SMK Editor
//
//  Created by Ian Sidor on 31/12/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObj.h"
#import "RomTypes.h"

@class RomObjTheme;
@class RomObjOverlay;

@interface RomObjTrack : RomObj

@property(strong) RomObjTheme			*theme;
@property(strong) NSData				*trackData;
@property(strong) NSImage				*image;
@property(strong) NSBitmapImageRep		*imageBitmap;
@property(assign) kRomTrack				trackType;
@property(strong) RomObjOverlay			*overlay;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range theme:(RomObjTheme*)theme overlay:(RomObjOverlay*)trackOverlay;
-(void)draw:(NSRect)rect;
-(NSString*)description;

@end

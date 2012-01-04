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
{
	RomObjTheme			*_theme;
	NSData				*trackData;
	NSImage				*image;
	NSBitmapImageRep	*imageBitmap;
	kRomTrack			trackType;
	RomObjOverlay		*overlay;
}

@property(nonatomic,retain) RomObjTheme			*theme;
@property(nonatomic,retain) NSData				*trackData;
@property(nonatomic,retain) NSImage				*image;
@property(nonatomic,retain) NSBitmapImageRep	*imageBitmap;
@property(nonatomic,assign) kRomTrack			trackType;
@property(nonatomic,retain) RomObjOverlay		*overlay;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range theme:(RomObjTheme*)theme overlay:(RomObjOverlay*)trackOverlay;
-(void)draw:(NSRect)rect;
-(NSString*)description;

@end

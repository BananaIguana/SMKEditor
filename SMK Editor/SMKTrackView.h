//
//  SMKTrackView.h
//  SMK Editor
//
//  Created by Ian Sidor on 01/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RomObjTrack;

@interface SMKTrackView : NSView
{
	RomObjTrack *track;
}

@property(nonatomic,retain) RomObjTrack *track;

@end

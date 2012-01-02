//
//  SMKTrackView.h
//  SMK Editor
//
//  Created by Ian Sidor on 01/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RomObjTrack;

typedef enum TrackViewOperationMode
{
	TrackViewOperationModeNone,
	TrackViewOperationModeRequestTranslate,
	TrackViewOperationModeRequestZoom,
	TrackViewOperationModeTranslating,
	TrackViewOperationModeZooming,
	
	TrackViewNumOperationModes,

}TrackViewOperationMode;

@interface SMKTrackView : NSView
{
	RomObjTrack					*track;
	TrackViewOperationMode		mode;

	NSPoint						trans;
	float						scale;
	float						scaleSource;
	NSPoint						currentPoint;
}

@property(nonatomic,retain)				RomObjTrack						*track;
@property(nonatomic,readonly,assign)	TrackViewOperationMode			mode;

@end

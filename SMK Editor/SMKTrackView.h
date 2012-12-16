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
	NSPoint						trans;
	CGFloat						scale;
	CGFloat						scaleSource;
	NSPoint						currentPoint;
	BOOL						_drawOverlay;
	BOOL						_drawAI;
}

@property(strong)				RomObjTrack						*track;
@property(readonly,assign)		TrackViewOperationMode			mode;
@property(assign)				BOOL							drawOverlay;
@property(assign)				BOOL							drawAI;

@end

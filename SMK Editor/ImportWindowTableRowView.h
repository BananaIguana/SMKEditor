//
//  ImportWindowTableRowView.h
//  SMK Editor
//
//  Created by Ian Sidor on 16/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface ImportWindowTableRowView : NSTableRowView
{
	BOOL							_mouseInside;
}

@property(strong) NSTrackingArea	*trackingArea;

@end

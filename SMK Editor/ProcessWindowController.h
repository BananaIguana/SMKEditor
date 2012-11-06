//
//  ProcessWindowController.h
//  SMK Editor
//
//  Created by Ian Sidor on 06/02/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TrackEditorWindow.h"
#import "DataRom.h"
#import "RomBase.h"

@interface ProcessWindowController : NSWindowController
{
	DataRom											*rom;
	TrackEditorWindow								*trackEditor;
	RomBase											*romBase;
}

@property(retain) DataRom							*rom;
@property(retain) TrackEditorWindow					*trackEditor;
@property(assign) IBOutlet NSProgressIndicator		*progress;
@property(retain) RomBase							*romBase;

@end

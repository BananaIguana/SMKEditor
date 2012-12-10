//
//  ProcessWindowController.h
//  SMK Editor
//
//  Created by Ian Sidor on 06/02/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

#import "TrackEditorWindow.h"
#import "DataRom.h"
#import "RomBase.h"
#import "DataRom+Helpers.h"

@interface ProcessWindowController : NSWindowController <DataRomExtractionProtocol>

@property(strong) NSManagedObjectID					*romID;
@property(strong) TrackEditorWindow					*trackEditor;
@property(weak) IBOutlet NSProgressIndicator		*progress;
@property(strong) RomBase							*romBase;
@property(weak) IBOutlet NSTextField				*textProgress;

@end

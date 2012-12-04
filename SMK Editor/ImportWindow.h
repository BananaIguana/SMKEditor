//
//  ImportWindow.h
//  SMK Editor
//
//  Created by Ian Sidor on 05/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <AppKit/AppKit.h>

@class TrackEditorWindow;

@interface ImportWindow : NSWindow <NSTableViewDelegate, NSTableViewDataSource>

@property(weak) IBOutlet NSTableView		*tableView;
@property(strong) NSArray					*dataRom;

@property(assign) NSInteger					selectedTableIndex;

@property(weak) IBOutlet NSTextField		*labelProjectName;
@property(weak) IBOutlet NSTextField		*labelCreated;
@property(weak) IBOutlet NSTextField		*labelUpdated;

@property(weak) IBOutlet NSButton			*buttonImport;
@property(weak) IBOutlet NSButton			*buttonClone;
@property(weak) IBOutlet NSButton			*buttonDelete;
@property(weak) IBOutlet NSButton			*buttonOpen;

@property(strong) TrackEditorWindow			*trackWindow;

@end

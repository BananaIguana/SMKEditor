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

@property(assign) IBOutlet NSTableView		*tableView;
@property(retain) NSArray					*dataRom;

@property(assign) NSInteger					selectedTableIndex;

@property(assign) IBOutlet NSTextField		*labelProjectName;
@property(assign) IBOutlet NSTextField		*labelCreated;
@property(assign) IBOutlet NSTextField		*labelUpdated;

@property(assign) IBOutlet NSButton			*buttonImport;
@property(assign) IBOutlet NSButton			*buttonClone;
@property(assign) IBOutlet NSButton			*buttonDelete;
@property(assign) IBOutlet NSButton			*buttonOpen;

@property(retain) TrackEditorWindow			*trackWindow;

@end

//
//  DataRom+Helpers.h
//  SMK Editor
//
//  Created by Ian Sidor on 30/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "DataRom.h"

@class RomBase;

@protocol DataRomExtractionProtocol <NSObject>

@optional

-(void)notifyExtractionSteps:(NSUInteger)steps;
-(void)notifyExtractedObject:(id)obj;

@end

@interface DataRom (Helpers)

-(RomBase*)extract;
-(RomBase*)extractWithDelegate:(id<DataRomExtractionProtocol>)delegate;

+(DataRom*)dataRomFromObjectID:(NSManagedObjectID*)romID viaManagedObjectContext:(NSManagedObjectContext*)context;

@end

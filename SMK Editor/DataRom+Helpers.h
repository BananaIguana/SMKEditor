//
//  DataRom+Helpers.h
//  SMK Editor
//
//  Created by Ian Sidor on 30/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "DataRom.h"

@class RomBase;

@interface DataRom (Helpers)

-(RomBase*)extract;

+(DataRom*)dataRomFromObjectID:(NSManagedObjectID*)romID viaManagedObjectContext:(NSManagedObjectContext*)context;

@end

//
//  DataRomManager.h
//  SMK Editor
//
//  Created by Ian Sidor on 19/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataRom.h"

typedef enum kDataRomRegion
{
	kDataRomRegionEurope,
	kDataRomRegionUSA,
	kDataRomRegionJapan,
	
	kDataRomNumRegions

}kDataRomRegion;

@interface DataRomManager : NSObject

@property(retain) NSManagedObjectContext			*context;
@property(retain) NSManagedObjectModel				*model;
@property(retain) NSPersistentStoreCoordinator		*storeCoordinator;

+(DataRomManager*)sharedInstance;

-(NSArray*)queryRomEntries;
-(NSManagedObject*)insertRomEntry:(NSURL*)url;

@end

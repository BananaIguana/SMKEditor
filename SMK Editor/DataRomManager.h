//
//  DataRomManager.h
//  SMK Editor
//
//  Created by Ian Sidor on 19/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataRom.h"
#import "Singleton.h"

typedef enum kDataRomRegion
{
	kDataRomRegionEurope,
	kDataRomRegionUSA,
	kDataRomRegionJapan,
	
	kDataRomNumRegions

}kDataRomRegion;

@interface DataRomManager : NSObject

@property(strong) NSManagedObjectContext			*context;
@property(strong) NSManagedObjectModel				*model;
@property(strong) NSPersistentStoreCoordinator		*storeCoordinator;

SINGLETON_INTERFACE( DataRomManager );

-(NSArray*)queryRomEntries;
-(NSManagedObject*)insertRomEntry:(NSURL*)url;

-(NSManagedObjectContext*)threadedContext;

@end

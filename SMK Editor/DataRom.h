//
//  DataRom.h
//  SMK Editor
//
//  Created by Ian Sidor on 26/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataRom : NSManagedObject

@property (nonatomic, retain) NSDate * dateImported;
@property (nonatomic, retain) NSDate * dateUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * region;
@property (nonatomic, retain) NSData * rom;
@property (nonatomic, retain) id icon;

@end

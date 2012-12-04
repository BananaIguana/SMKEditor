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

@property (nonatomic, strong) NSDate * dateImported;
@property (nonatomic, strong) NSDate * dateUpdated;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * region;
@property (nonatomic, strong) NSData * rom;
@property (nonatomic, strong) id icon;

@end

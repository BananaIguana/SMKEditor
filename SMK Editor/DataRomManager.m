//
//  DataRomManager.m
//  SMK Editor
//
//  Created by Ian Sidor on 19/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DataRomManager.h"
#import "DataRom.h"

@implementation DataRomManager

static DataRomManager *gDataRomManager = nil;

@synthesize context;
@synthesize model;
@synthesize storeCoordinator;

+(DataRomManager*)sharedInstance
{
	@synchronized( self )
	{
		if( gDataRomManager == nil )
		{
			gDataRomManager = [[super allocWithZone:NULL] init];
		}
	}

	return( gDataRomManager );
}

+(id)allocWithZone:(NSZone*)zone
{
	return [[self sharedInstance] retain];
}

-(id)copyWithZone:(NSZone*)zone
{
	return( self );
}

-(id)retain
{
	return( self );
}

-(NSUInteger)retainCount
{
	return( UINT_MAX );
}

-(oneway void)release
{

}

-(id)autorelease
{
    return( self );
}

-(id)init
{
	self = [super init];
	
	if( self )
	{
		self.model					= [NSManagedObjectModel mergedModelFromBundles:nil];		
		self.storeCoordinator		= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
		
		NSBundle *bundle			= [NSBundle mainBundle];
		
		NSURL *url					= [bundle bundleURL];
		
		url							= [NSURL URLWithString:@"Contents/Resources/store.xml" relativeToURL:url];
		
		NSError *error;
				
		[self.storeCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error];
		
		self.context				= [[NSManagedObjectContext alloc] init];
		
		[self.context setPersistentStoreCoordinator:self.storeCoordinator];	
	}
	
	return( self );
}

-(NSArray*)queryRomEntries
{
	NSEntityDescription *desc		= [NSEntityDescription entityForName:@"DataRom" inManagedObjectContext:self.context];
	
	NSFetchRequest *request			= [[[NSFetchRequest alloc] init] autorelease];
	
	NSSortDescriptor *sort			= [[[NSSortDescriptor alloc] initWithKey:@"dateUpdated" ascending:YES] autorelease];

	[request setSortDescriptors:@[sort]];	
	[request setEntity:desc];
	
	NSError *error;
	
	NSArray *array					= [self.context executeFetchRequest:request error:&error];
	
	return( array );
}

-(NSManagedObject*)insertRomEntry:(NSURL*)url
{
	NSData *data					= [NSData dataWithContentsOfURL:url];
	DataRom *newObj					= nil;

	if( data )
	{
		newObj						= [NSEntityDescription insertNewObjectForEntityForName:@"DataRom" inManagedObjectContext:self.context];

		NSString *lastComponent		= [[url pathComponents] lastObject];

		newObj.rom					= data;
		newObj.name					= lastComponent ? lastComponent : @"New Rom";

		NSDate *date				= [NSDate date];

		newObj.dateImported			= date;
		newObj.dateUpdated			= date;
	}
	
	NSError *error;
	
	[self.context save:&error];
	
	return( newObj );
}

/*
-(DataRom*)createDataEntryForImportPath:(NSString*)path
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataRom" inManagedObjectContext:managedObjectContext];
  
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
  
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];  
    [sortDescriptor release];   

}*/

@end

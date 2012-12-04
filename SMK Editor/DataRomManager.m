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

@interface DataRomManager()

@end

@implementation DataRomManager

SINGLETON_IMPLEMENTATION( DataRomManager );

-(id)init
{
	self = [super init];
	
	if( self )
	{
		self.model										= [NSManagedObjectModel mergedModelFromBundles:nil];
		self.storeCoordinator							= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
		
		NSBundle *bundle								= [NSBundle mainBundle];
		
		NSURL *url										= [bundle bundleURL];
		
		url												= [NSURL URLWithString:@"Contents/Resources/store.xml" relativeToURL:url];
		
		NSError *error									= nil;
				
		[self.storeCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error];
		
		self.context									= [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		
		[self.context setPersistentStoreCoordinator:self.storeCoordinator];
		
		// Threaded notification
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
	}
	
	return( self );
}

-(NSArray*)queryRomEntries
{
	NSEntityDescription *desc							= [NSEntityDescription entityForName:@"DataRom" inManagedObjectContext:self.context];
	
	NSFetchRequest *request								= [[NSFetchRequest alloc] init];
	
	NSSortDescriptor *sort								= [[NSSortDescriptor alloc] initWithKey:@"dateUpdated" ascending:YES];

	[request setSortDescriptors:@[sort]];	
	[request setEntity:desc];
	
	NSError *error;
	
	NSArray *array										= [self.context executeFetchRequest:request error:&error];
	
	return( array );
}

-(NSManagedObject*)insertRomEntry:(NSURL*)url
{
	NSData *data										= [NSData dataWithContentsOfURL:url];
	DataRom *newObj										= nil;

	if( data )
	{
		newObj											= [NSEntityDescription insertNewObjectForEntityForName:@"DataRom" inManagedObjectContext:self.context];

		NSString *lastComponent							= [[url pathComponents] lastObject];

		newObj.rom										= data;
		newObj.name										= lastComponent ? lastComponent : @"New Rom";

		NSDate *date									= [NSDate date];

		newObj.dateImported								= date;
		newObj.dateUpdated								= date;
	}
	
	NSError *error;
	
	[self.context save:&error];
	
	return( newObj );
}

-(NSManagedObjectContext*)threadedContext
{
	NSManagedObjectContext *tc							= [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	
	tc.parentContext									= self.context;
		
//	[tc setPersistentStoreCoordinator:self.storeCoordinator];
	
	return( tc );
}

#pragma mark -
#pragma mark Notifications

-(void)handleDidSaveNotification:(NSNotification*)notification
{
	dispatch_async( dispatch_get_main_queue(), ^{

		[self.threadedContext mergeChangesFromContextDidSaveNotification:notification];
	});
}

@end

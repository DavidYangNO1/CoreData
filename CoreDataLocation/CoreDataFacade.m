//
//  CoreDataFacade.m
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CoreDataFacade.h"

#define CoreDataMOMD       @"CoreDataLocation"
#define CoreMOMDType       @"momd"
#define CoreDatabasename   @"CoreDataLocation.CDBStore"
#define DatabaseName       @"CoreDataLocation"
#define DatabaseType       @"CDBStore"

@interface CoreDataFacade(PrvateMethod) 

-(NSURL *)applicationDocumentsDirectory;

@end

@implementation CoreDataFacade

@synthesize managedObjectModel;

@synthesize managedObjectContext;

@synthesize persistentStoreCoordinator;

@synthesize entitylists;

#pragma mark - property define

-(NSURL *)applicationDocumentsDirectory {
	
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

-(NSManagedObjectModel*)getManagedObjectModel{
    
    if (managedObjectModel!=nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CoreDataMOMD withExtension:CoreMOMDType]; 
    
    NSManagedObjectModel * model =[[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    self.managedObjectModel=model;
    [model release];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator*)getPersistentStoreCoordinator{
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:CoreDatabasename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:DatabaseName withExtension:DatabaseType];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSPersistentStoreCoordinator * perSc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self getManagedObjectModel]];
    persistentStoreCoordinator =perSc;
    [perSc release];
    NSError *error;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

-(NSManagedObjectContext*)getManagedObjectContext{
    
    if (managedObjectContext!=nil) {
        return managedObjectContext;
    }
    
    NSManagedObjectContext * context =[[NSManagedObjectContext alloc]init];
    self.managedObjectContext=context;
    [context release];
    [self.managedObjectContext setPersistentStoreCoordinator:[self getPersistentStoreCoordinator]];
    
    return managedObjectContext;
}

#pragma mark business logic

-(void)fetchEntityLists:(id)object{
    
    NSFetchRequest * fetchRequest =[[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity =[[NSEntityDescription alloc]init];
    
    [entity setName:NSStringFromClass([object class])];
    
    [entity setManagedObjectClassName:NSStringFromClass([object class])];
    
    [fetchRequest setEntity:entity];
    
    NSError * error=nil;
    
    NSMutableArray *mutableFetchResults =[[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [self setEntitylists:mutableFetchResults];
    
    [mutableFetchResults release];
    [fetchRequest release];
    [entity release];
}

-(void)saveContext{
    
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        // handle the error
    }
}

-(void)removeEntity:(NSManagedObject*)mb{
    
    [self.managedObjectContext deleteObject:mb];
    
    [self.entitylists removeObject:mb];
    
    [self saveContext];
}

/**
 *
 *
 * object =[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([object class]) inManagedObjectContext:self.managedObjectContext];
 *
**/
-(void)addEntity:(id)object{
    
    [self saveContext];
    
    [self.entitylists addObject:object];
    
}
@end

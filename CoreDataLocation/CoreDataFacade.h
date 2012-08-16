//
//  CoreDataFacade.h
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataFacade : NSObject
{

}

@property(nonatomic,retain,getter = getManagedObjectModel) NSManagedObjectModel *managedObjectModel;

@property(nonatomic,retain,getter = getManagedObjectContext) NSManagedObjectContext * managedObjectContext;

@property(nonatomic,retain,getter =getPersistentStoreCoordinator) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@property(nonatomic,retain) NSMutableArray * entitylists;

/**
 *
 *
 * fetch entity list from data source
 *
 *
**/
-(void)fetchEntityLists:(id)object;

/**
 *
 *commit the change
 *
**/
-(void)saveContext;

/**
 *
 *
 * remove entiry between context and array source
 *
 *
 **/
-(void)removeEntity:(NSManagedObject*)mb;

/**
 *
 *
 * add entity to persisten data base or file
 *
 *
**/ 
-(void)addEntity:(id)object;

@end

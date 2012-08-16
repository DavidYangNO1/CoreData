//
//  AppDelegate.h
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property(nonatomic,retain)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,retain)NSManagedObjectContext*managedObjectContext;
@property(nonatomic,retain)NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) UINavigationController *navigationController;

@end

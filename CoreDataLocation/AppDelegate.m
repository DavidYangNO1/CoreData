//
//  AppDelegate.m
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize applicationDocumentsDirectory;
@synthesize navigationController;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [managedObjectModel release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewController *rootViewController = [[ViewController alloc] initWithStyle:UITableViewStylePlain];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}
	rootViewController.managedObjectContext = context;
	
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.navigationController = aNavigationController;
	self.window =[[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	[self.window addSubview:[navigationController view]];
	[self.window makeKeyAndVisible];
	
	[rootViewController release];
	[aNavigationController release];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSError * error;
    if (managedObjectContext !=nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        }
    }
}

#pragma mark business logic

- (NSURL *)applicationDocumentsDirectory {
	
   return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

-(NSManagedObjectModel*)managedObjectModel{
    if (managedObjectModel!=nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataLocation" withExtension:@"momd"];

    NSManagedObjectModel * model =[[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    self.managedObjectModel=model;
    [model release];
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
     NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataLocation.CDBStore"];
    
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataLocation.CDBStore"];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"CoreDataLocation" withExtension:@"CDBStore"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
               NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

-(NSManagedObjectContext*) managedObjectContext{
    
    if (managedObjectContext!=nil) {
        return managedObjectContext;
    }
   
    NSManagedObjectContext * context =[[NSManagedObjectContext alloc]init];
    self.managedObjectContext=context;
    //[context release];
    NSLog(@"self.managedObjectContext %ud",self.managedObjectContext.retainCount);
    [self.managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    
    return managedObjectContext;
}
@end

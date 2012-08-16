//
//  ViewController.h
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UITableViewController<CLLocationManagerDelegate>{
    NSMutableArray * eventsArray;
    NSManagedObjectContext * managedObjectContext;
    
    CLLocationManager * locationManager;
    UIBarButtonItem * addButton;
    
}

@property(nonatomic,retain)NSMutableArray * eventsArray;
@property(nonatomic,retain)NSManagedObjectContext * managedObjectContext;

@property(nonatomic,retain)CLLocationManager * locationManager;
@property(nonatomic,retain)UIBarButtonItem * addButton;

//@property(nonatomic,retain)IBOutlet UITableView *tableView;
-(void)addEvent;
@end

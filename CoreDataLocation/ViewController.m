//
//  ViewController.m
//  CoreDataLocation
//
//  Created by lsp on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Event.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize eventsArray;

@synthesize managedObjectContext;

@synthesize locationManager;

@synthesize addButton;

//@synthesize tableView;

-(void)dealloc{
    [self.eventsArray release];
    [self.managedObjectContext release];
    [self.locationManager release];
    [self.addButton release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the title.
    self.title = @"CoreDataExample";
    
	// Configure the add and edit buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	addButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = addButton;
    
	// Start the location manager.
   
   
   
	[[self locationManager] startUpdatingLocation];
	
	/*
	 Fetch existing events.
	 Create a fetch request; find the Event entity and assign it to the request; add a sort descriptor; then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	//NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	//[request setEntity:entity];
	
    NSEntityDescription *runEntity = [[NSEntityDescription alloc] init];
    [runEntity setName:@"Event"];
    [runEntity setManagedObjectClassName:@"Event"];
    [request setEntity:runEntity];
    
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setEventsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
    [runEntity release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.eventsArray =nil;
    self.locationManager=nil;
    self.addButton=nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark table view delegate implemethod

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Get the event corresponding to the current index path and configure the table view cell.
	Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
	
	NSString *string = [NSString stringWithFormat:@"%@, %@",
						[numberFormatter stringFromNumber:[event latitude]],
						[numberFormatter stringFromNumber:[event longitude]]];
    cell.detailTextLabel.text = string;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
    }   
}


/**
 Add an event.
 */
-(void)addEvent{
	
	// If it's not possible to get a location, then return.
	CLLocation *location = [self.locationManager location];
	if (!location) {
		return;
	}
	
	/*
	 Create a new instance of the Event entity.
	 */
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = [location coordinate];
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	
	// Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:[NSDate date]];
	
	// Commit the change.
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    [eventsArray insertObject:event atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView reloadData];
}

-(CLLocationManager*)locationManager{
    if (locationManager!=nil) {
        return locationManager;
    }
    locationManager =[[CLLocationManager alloc]init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager setDelegate:self];
    return locationManager;
                      
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    addButton.enabled = YES;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    addButton.enabled=NO;
}

@end

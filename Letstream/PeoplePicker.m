//
//  PeoplePicker.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "PeoplePicker.h"
#import "Person.h"
#import <AddressBook/AddressBook.h>

@implementation PeoplePicker

@synthesize personObjects, selectedObjects;

- (id)initWithPersonObjects:(NSArray *)initPersonObjects
{
	if ((self = [super initWithNibName:@"PeoplePicker" bundle:nil])) personObjects = [[Person sortedPersonObjects:initPersonObjects] retain];
	return self;
}

- (NSArray *)selectedObjects
{
	if (!selectedObjects) selectedObjects = [[NSMutableArray alloc] init];
	return (NSArray *)selectedObjects;
}

- (void)dealloc
{
	[selectedObjects release];
	[personObjects release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setClearsSelectionOnViewWillAppear:YES];	
}

- (void)viewWillAppear:(BOOL)animated
{
	[(NSMutableArray *)[self selectedObjects] removeAllObjects];
	[(UITableView *)[self view] reloadData];
	[super viewWillAppear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [personObjects count]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeoplePickerCell";
    
    UITableViewCell *cell;;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
	Person *person = (Person *)[personObjects objectAtIndex:[indexPath row]];
	
  	[[cell textLabel] setText:[person name]];
	[[cell detailTextLabel] setText:[[[person groups] allObjects] componentsJoinedByString:@", "]];
	[cell setAccessoryType:[selectedObjects containsObject:person] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    
    return cell;
}

- (id)representedObjectForIndexPath:(NSIndexPath *)indexPath
{
	if (!((NSUInteger)[indexPath row] < [personObjects count])) return nil;
	
	return [personObjects objectAtIndex:[indexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	
	if (![[self selectedObjects] containsObject:[self representedObjectForIndexPath:indexPath]])
	{
		[(NSMutableArray *)selectedObjects addObject:[self representedObjectForIndexPath:indexPath]];
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else
	{
		[(NSMutableArray *)selectedObjects removeObject:[self representedObjectForIndexPath:indexPath]];
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

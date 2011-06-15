//
//  PeoplePicker.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "PeoplePicker.h"
#import "Person.h"
#import <AddressBook/AddressBook.h>

@implementation PeoplePicker

@synthesize personObjects, selectedObjects;

- (id)initWithPersonObjects:(NSArray *)initPersonObjects
{
	if ((self = [super initWithNibName:@"PeoplePicker" bundle:nil])) personObjects = [initPersonObjects copy];
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
	[self setClearsSelectionOnViewWillAppear:NO];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier])) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
  	[[cell textLabel] setText:[(Person *)[personObjects objectAtIndex:[indexPath row]] description]];
    
    return cell;
}

- (id)representedObjectForIndexPath:(NSIndexPath *)indexPath
{
	if (!([indexPath row] < [personObjects count])) return nil;
	
	return [personObjects objectAtIndex:[indexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	
	if ([self representedObjectForIndexPath:indexPath])
	{
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
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

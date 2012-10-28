//
//  TimeframePicker.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/18.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "TimeframePicker.h"


@implementation TimeframePicker

- (id)init
{
	if ((self = [super initWithNibName:@"TimeframePicker" bundle:nil]))
	{
		options = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Timeframe" ofType:@"plist"]];
		selectedIndexes = [[NSMutableSet alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[options release];
	[selectedIndexes release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSArray *)objectsInSection:(NSInteger)section
{
	NSString *key = [[options allKeys] objectAtIndex:section];
	if ([[(NSArray *)[options objectForKey:key] lastObject] isKindOfClass:[NSDictionary class]]) return [[options objectForKey:key] valueForKeyPath:@"label"];
	return [options objectForKey:key];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return !section ? @"Days of Week" : @"Times of Day"; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [[self objectsInSection:section] count]; }

- (UITableViewCellAccessoryType)cellAccessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath { return [selectedIndexes containsObject:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GenericCell";
    
    UITableViewCell *cell;;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]))
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[[cell textLabel] setText:[[self objectsInSection:[indexPath section]] objectAtIndex:[indexPath row]]];
	[cell setAccessoryType:[self cellAccessoryTypeForRowAtIndexPath:indexPath]];

   	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([selectedIndexes containsObject:indexPath]) [selectedIndexes removeObject:indexPath];
	else [selectedIndexes addObject:indexPath];
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:[self cellAccessoryTypeForRowAtIndexPath:indexPath]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

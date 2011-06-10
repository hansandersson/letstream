//
//  BrowseTableViewController.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "BrowseTableViewController.h"


@implementation BrowseTableViewController

@synthesize sections, sectionObjects;

- (NSArray *)sections
{
	if (!sections) sections = [[NSArray alloc] initWithObjects:@"Who", @"What", @"Where", @"When", nil];
	return sections;
}

- (NSDictionary *)sectionObjects
{
	if (!sectionObjects)
	{
		NSMutableDictionary *sectionObjectsMutable = [NSMutableDictionary dictionaryWithCapacity:[[self sections] count]];
		for (NSString *section in [self sections]) [sectionObjectsMutable setObject:[NSArray array] forKey:section];
		sectionObjects = [sectionObjectsMutable copy];
	}
	return sectionObjects;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
	{
		//...
    }
    return self;
}

- (void)dealloc
{
	if (sections) [sections release];
	if (sectionObjects) [sectionObjects release];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return [[self sections] count]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [(NSArray *)[[self sectionObjects] objectForKey:[[self sections] objectAtIndex:section]] count] + 1; }

- (NSString *)stringForIndexPath:(NSIndexPath *)indexPath { return [[[self sectionObjects] objectForKey:[[self sections] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]]; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return [[self sections] objectAtIndex:section]; }

- (BOOL)isAdderForIndexPath:(NSIndexPath *)indexPath { return !([indexPath row] < [[[self sectionObjects] objectForKey:[[self sections] objectAtIndex:[indexPath section]]] count]); }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	#define CELLTYPE_ADD @"BrowseCellAdd"
	#define CELLTYPE_DEFAULT @"BrowseCellDefault"
	
	NSString *CELLTYPE = [self isAdderForIndexPath:indexPath] ? CELLTYPE_ADD : CELLTYPE_DEFAULT;
    
    UITableViewCell *cell;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CELLTYPE]))
	{
		if ([CELLTYPE isEqualToString:CELLTYPE_ADD])
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLTYPE] autorelease];
			[[cell textLabel] setTextColor:[UIColor lightGrayColor]];
			[[cell textLabel] setText:@"Add…"];
    		[cell setAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
			[(UIButton *)[cell accessoryView] addTarget:self action:@selector(tappedAdder:) forControlEvents:UIControlEventTouchUpInside];
		}
		else
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLTYPE] autorelease];
			[[cell textLabel] setTextAlignment:UITextAlignmentLeft];
			[[cell textLabel] setTextColor:[UIColor darkTextColor]];
    		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
	}
	
	if (![CELLTYPE isEqualToString:CELLTYPE_ADD]) [[cell textLabel] setText:[self stringForIndexPath:indexPath]];

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
	if ([self isAdderForIndexPath:indexPath]) [self tappedAdder:[[tableView cellForRowAtIndexPath:indexPath] accessoryView]];
}

- (IBAction)tappedAdder:(id)sender
{
	UITableViewCell *tableCell = (UITableViewCell *)[sender superview];
	UITableView *tableView = (UITableView *)[tableCell superview];
	NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
	[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:NO];
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

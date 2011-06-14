//
//  SearchDetailsViewController.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import "LetstreamAppDelegate.h"
#import "Record.h"

@implementation SearchDetailsViewController

@synthesize representedObject, managedObjectContext;
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

- (id)initWithRepresentedObject:(NSManagedObject *)initRepresentedObject
{
	if ((self = [self initWithManagedObjectContext:[initRepresentedObject managedObjectContext]]))
	{
		representedObject = initRepresentedObject;
		[representedObject retain];
    }
    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)initManagedObjectContext
{
	if ((self = [super initWithNibName:@"SearchDetailsViewController" bundle:nil]))
	{
		managedObjectContext = initManagedObjectContext;
		[managedObjectContext retain];
    }
    return self;
}

- (void)dealloc
{
	[sections release];
	[sectionObjects release];
	[representedObject release];
	[managedObjectContext release];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == (NSInteger) [[self sections] indexOfObject:@"Who"])
	{
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext]];
		NSUInteger count = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] count];
		[fetchRequest release];
		return count + 1;
	}
	else if (section == (NSInteger) [[self sections] indexOfObject:@"What"]) return 1;
	else if (section == (NSInteger) [[self sections] indexOfObject:@"Where"]) return 1;
	else if (section == (NSInteger) [[self sections] indexOfObject:@"When"]) return 1;
	
	return 0;
}

- (NSString *)stringForIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == [[self sections] indexOfObject:@"Who"])
	{
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext]];
		NSError *error = nil;
		NSArray *groups = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		if (error) NSLog(@"%@", error);
		[fetchRequest release];
		
		if ([indexPath row] == [groups count]) return @"Add…";
		
		return [(Record *)[groups objectAtIndex:[indexPath row]] name];
	}
	else if ([indexPath section] == [[self sections] indexOfObject:@"What"]) return @"What";
	else if ([indexPath section] == [[self sections] indexOfObject:@"Where"]) return @"Where";
	else if ([indexPath section] == [[self sections] indexOfObject:@"When"]) return @"When";
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return [[self sections] objectAtIndex:section]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	#define CELLTYPE_ADD @"SearchCellAdd"
	#define CELLTYPE_DEFAULT @"SearchCellDefault"
	
	NSString *cellTextLabelStringValue = [self stringForIndexPath:indexPath];
	
	NSString *CELLTYPE = [cellTextLabelStringValue isEqualToString:@"Add…"] ? CELLTYPE_ADD : CELLTYPE_DEFAULT;
    
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
	if ([[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqualToString:@"Add…"]) [self tappedAdder:[[tableView cellForRowAtIndexPath:indexPath] accessoryView]];
}

- (IBAction)tappedAdder:(id)sender
{
	UITableViewCell *tableCell = (UITableViewCell *)[sender superview];
	UITableView *tableView = (UITableView *)[tableCell superview];
	NSIndexPath *indexPath = [tableView indexPathForCell:tableCell];
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:NO];
}

@end

//
//  SearchDetailsViewController.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "Responder.h"

#import "SearchDetailsViewController.h"
#import "Group.h"
#import "Tag.h"

#import "PeoplePicker.h"
#import "RegionPicker.h"
#import "TimeframePicker.h"

#import "SearchDetailsSection.h"

@implementation SearchDetailsViewController

@synthesize representedObject, managedObjectContext;
@synthesize sections, selectedObjects;

- (NSArray *)sections
{
	if (!sections)
	{
		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		NSError *error;
		
		error = nil;
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext]];
		SearchDetailsSection *who = [[[SearchDetailsSection alloc] initWithTitle:@"Who" representedObjects:[managedObjectContext executeFetchRequest:fetchRequest error:&error]] autorelease];
		if (error) NSLog(@"%@", error);
		
		error = nil;
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:managedObjectContext]];
		PeoplePicker *peoplePicker = [[[PeoplePicker alloc] initWithPersonObjects:[managedObjectContext executeFetchRequest:fetchRequest error:&error]] autorelease];
		if (error) NSLog(@"%@", error);
		
		[[peoplePicker navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(newGroup:)] autorelease]];
		[peoplePicker setTitle:@"Create Group…"];
		
		
		
		NSString *placeholder = @"Group Name";
		UITextField *nameField = [[UITextField alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[nameField setFont:[UIFont boldSystemFontOfSize:14.0f]];
		[nameField setFrame:CGRectMake([nameField frame].origin.x, [nameField frame].origin.y, [nameField frame].size.width, 24.0f)];
		[nameField setPlaceholder:placeholder];
		[nameField setBorderStyle:UITextBorderStyleBezel];
		[nameField setBackgroundColor:[UIColor whiteColor]];
		[nameField setReturnKeyType:UIReturnKeyDone];
		[nameField setDelegate:self];
		[[peoplePicker navigationItem] setTitleView:nameField];
		
		[nameField release];
		
		[who setEditViewController:peoplePicker];
		
		error = nil;
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:managedObjectContext]];
		SearchDetailsSection *what = [[[SearchDetailsSection alloc] initWithTitle:@"What" representedObjects:[managedObjectContext executeFetchRequest:fetchRequest error:&error]] autorelease];
		if (error) NSLog(@"%@", error);
		
		SearchDetailsSection *where = [[[SearchDetailsSection alloc] initWithTitle:@"Where" representedObjects:[NSArray array]] autorelease];
		
		RegionPicker *regionPicker = [[[RegionPicker alloc] init] autorelease];
		[regionPicker setTitle:@"Select Area…"];
		[where setEditViewController:regionPicker];
		
		TimeframePicker *timeframePicker = [[[TimeframePicker alloc] init] autorelease];
		[timeframePicker setTitle:@"Select Timeframe(s)…"];
		SearchDetailsSection *when = [[[SearchDetailsSection alloc] initWithTitle:@"When" representedObjects:[NSArray array]] autorelease];
		[when setEditViewController:timeframePicker];
		
		sections = [[NSArray alloc] initWithObjects:who, what, where, when, nil];
	}
	return sections;
}

- (NSSet *)selectedObjects
{
	if (!selectedObjects) selectedObjects = [[NSMutableSet alloc] init];
	return (NSSet *)selectedObjects;
}

- (id)initWithRepresentedObject:(NSManagedObject *)initRepresentedObject
{
	if ((self = [self initWithManagedObjectContext:[initRepresentedObject managedObjectContext]]))
	{
		representedObject = initRepresentedObject;
		[representedObject retain];
		
		for (Group *group in [representedObject valueForKey:@"groups"]) [(NSMutableSet *)[self selectedObjects] addObject:group];
		for (Tag *tag in [representedObject valueForKey:@"tags"]) [(NSMutableSet *)[self selectedObjects] addObject:tag];
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
	[representedObject release];
	[managedObjectContext release];
	[selectedObjects release];
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
	if ([self navigationController]) [[self navigationController] setDelegate:self];
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
	[[self navigationController] setToolbarHidden:YES animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [(SearchDetailsSection *)[[self sections] objectAtIndex:section] rowsCount]; }

- (id)representedObjectForIndexPath:(NSIndexPath *)indexPath
{
	if (!((NSUInteger)[indexPath section] < [[self sections] count])) return nil;
	
	SearchDetailsSection *section = [[self sections] objectAtIndex:[indexPath section]];
	
	if (!((NSUInteger)[indexPath row] < [[section representedObjects] count])) return nil;
	
	return [[section representedObjects] objectAtIndex:[indexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return [(SearchDetailsSection *)[[self sections] objectAtIndex:section] title]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	#define CELLTYPE_EDIT @"SearchCellEdit"
	#define CELLTYPE_DEFAULT @"SearchCellDefault"
	
	NSString *cellTextLabelStringValue = [[self representedObjectForIndexPath:indexPath] description];
	NSString *CELLTYPE = cellTextLabelStringValue ? CELLTYPE_DEFAULT : CELLTYPE_EDIT;
    
    UITableViewCell *cell;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CELLTYPE]))
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLTYPE] autorelease];
		
		if (CELLTYPE == CELLTYPE_EDIT)
		{
			[[cell textLabel] setTextColor:[UIColor lightGrayColor]];
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		}
	}
	
	if (CELLTYPE != CELLTYPE_EDIT)
	{
		[[cell textLabel] setText:[[self representedObjectForIndexPath:indexPath] description]];
		[cell setAccessoryType:[[self selectedObjects] containsObject:[self representedObjectForIndexPath:indexPath]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	else [[cell textLabel] setText:[[(SearchDetailsSection *)[[self sections] objectAtIndex:[indexPath section]] editViewController] title]];

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return !![self representedObjectForIndexPath:indexPath]; }

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        // Delete the row from the data source
		id deletedObject = [self representedObjectForIndexPath:indexPath];
		[self selectedObjects];
		[selectedObjects removeObject:deletedObject];
		[[(SearchDetailsSection *)[[self sections] objectAtIndex:[indexPath section]] representedObjects] removeObject:deletedObject];
		[managedObjectContext deleteObject:deletedObject];
		if ([[[[self sections] objectAtIndex:[indexPath section]] title] isEqualToString:@"Who"])
		{
			ABAddressBookRef addressBookRef = ABAddressBookCreate();
			ABAddressBookRemoveRecord(addressBookRef, ABAddressBookGetGroupWithRecordID(addressBookRef, [[(Group *)deletedObject identifier] intValue]), NULL);
			ABAddressBookSave(addressBookRef, NULL);
			CFRelease(addressBookRef);
		}
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[textField setText:nil];
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	/*if (![[textField text] isEqualToString:@""])
	{
		SearchDetailsSection *section = [[self sections] objectAtIndex:[textField tag]];
		NSIndexPath *newObjectIndexPath = [NSIndexPath indexPathForRow:[[section representedObjects] count] inSection:[textField tag]];
		
		id newObject = nil;
		
		if ([[section title] isEqualToString:@"Who"]) newObject = [Group groupWithName:[textField text] inManagedObjectContext:managedObjectContext];
		else if ([[section title] isEqualToString:@"What"]) newObject = [Tag tagWithText:[textField text] inManagedObjectContext:managedObjectContext];
		
		[[section representedObjects] addObject:newObject];
			
		[(UITableView *)[self view] insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[newObjectIndexPath row] inSection:[newObjectIndexPath section]]] withRowAnimation:UITableViewRowAnimationTop];
		
		[textField setText:nil];
		
		[(UITableView *)[self view] reloadSections:[NSIndexSet indexSetWithIndex:[textField tag]] withRowAnimation:UITableViewRowAnimationNone];
	}*/
	[textField resignFirstResponder];
	return YES;
}

- (void)newGroup:(id)sender
{
	PeoplePicker *peoplePicker = (PeoplePicker *)[[self navigationController] topViewController];
	
	SearchDetailsSection *section = [[self sections] objectAtIndex:0];
	NSIndexPath *newObjectIndexPath = [NSIndexPath indexPathForRow:[section rowsCount] inSection:0];
	
	Group *newGroup = [Group groupWithName:[(UITextView *)[[peoplePicker navigationItem] titleView] text] insertIntoManagedObjectContext:managedObjectContext];
	
	[[section representedObjects] addObject:newGroup];
	
	[[self navigationController] popToViewController:self animated:YES];
	[(UITextView *)[[peoplePicker navigationItem] titleView] setText:nil];
	
	[(UITableView *)[self view] insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[newObjectIndexPath row] inSection:[newObjectIndexPath section]]] withRowAnimation:UITableViewRowAnimationTop];
	
	[(UITableView *)[self view] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	UIViewController *editViewController = [(SearchDetailsSection *)[[self sections] objectAtIndex:[indexPath section]] editViewController];
	if ([[editViewController toolbarItems] count] > 0) [[self navigationController] setToolbarHidden:NO animated:YES];
	[[self navigationController] pushViewController:editViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	
	if ([self representedObjectForIndexPath:indexPath])
	{
		if (![[self selectedObjects] containsObject:[self representedObjectForIndexPath:indexPath]])
		{
			[selectedObjects addObject:[self representedObjectForIndexPath:indexPath]];
			[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		else
		{
			[selectedObjects removeObject:[self representedObjectForIndexPath:indexPath]];
			[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	
	if ([[[[self navigationController] topViewController] view] findAndResignFirstResponder]) return;
	else if ([[[[[self navigationController] topViewController] navigationItem] titleView] findAndResignFirstResponder]) return;
	NSLog(@"firstResponder not found");
}

@end

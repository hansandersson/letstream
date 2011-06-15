//
//  SearchDetailsViewController.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import "Group.h"
#import "Tag.h"

#import "PeoplePicker.h"

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
		PeoplePicker *peoplePicker = [[PeoplePicker alloc] initWithPersonObjects:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
		if (error) NSLog(@"%@", error);
		
		[[peoplePicker navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(newGroup:)] autorelease]];
		//SHOULD SET TITLE VIEW TO A TEXTFIELD FOR NAMING
		[[peoplePicker navigationItem] setTitleView:nil];
		
		[who setEditViewController:peoplePicker];
		
		error = nil;
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:managedObjectContext]];
		SearchDetailsSection *what = [[[SearchDetailsSection alloc] initWithTitle:@"What" representedObjects:[managedObjectContext executeFetchRequest:fetchRequest error:&error]] autorelease];
		if (error) NSLog(@"%@", error);
		
		SearchDetailsSection *where = [[[SearchDetailsSection alloc] initWithTitle:@"Where" representedObjects:[NSArray array]] autorelease];
		
		//UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 216.0f)];
		//[datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
		//[datePicker setMinuteInterval:5];
		SearchDetailsSection *when = [[[SearchDetailsSection alloc] initWithTitle:@"When" representedObjects:[NSArray array]] autorelease];
		//[[when editViews] addObject:datePicker];
		//[datePicker release];
		
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [(SearchDetailsSection *)[[self sections] objectAtIndex:section] rowsCount]; }

- (id)representedObjectForIndexPath:(NSIndexPath *)indexPath
{
	if (!([indexPath section] < [[self sections] count])) return nil;
	
	SearchDetailsSection *section = [[self sections] objectAtIndex:[indexPath section]];
	
	if (!([indexPath row] < [[section representedObjects] count])) return nil;
	
	return [[section representedObjects] objectAtIndex:[indexPath row]];
}

- (UIView *)editViewForIndexPath:(NSIndexPath *)indexPath
{
	SearchDetailsSection *section = [[self sections] objectAtIndex:[indexPath section]];
	return [[section editViews] objectAtIndex:([indexPath row]-[[section representedObjects] count])];
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
		
		if (CELLTYPE == CELLTYPE_EDIT) [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		else [[cell textLabel] setTextColor:[UIColor darkTextColor]];
	}
	
	if (CELLTYPE != CELLTYPE_EDIT)
	{
		[[cell textLabel] setText:[[self representedObjectForIndexPath:indexPath] description]];
		[cell setAccessoryType:[[self selectedObjects] containsObject:[self representedObjectForIndexPath:indexPath]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
	}
	else
	{
		for (UIView *subview in [[cell contentView] subviews]) [subview removeFromSuperview];
		
		CGRect contentViewBounds = [[cell contentView] bounds];
		
		UIView *editView = [self editViewForIndexPath:indexPath];
		
		const CGSize padding = CGSizeMake(10.0f, 10.0f);
		[editView setFrame:CGRectMake(padding.width, padding.height, contentViewBounds.size.width - 2.0f*padding.width, [editView frame].size.height)];
		[editView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[editView setTag:[indexPath section]];
		
		[[cell contentView] addSubview:editView];
	}

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self representedObjectForIndexPath:indexPath]) return [tableView rowHeight];
	
	UIView *editView = [self editViewForIndexPath:indexPath];
	return 23.0f + [editView frame].size.height;
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
	//UIBarButtonItem *saveButton = (UIBarButtonItem *)sender;
	[[self navigationController] popToViewController:self animated:YES];
}

#pragma mark - Table view delegate

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
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

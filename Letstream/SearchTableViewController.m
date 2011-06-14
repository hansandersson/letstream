//
//  SearchTableViewController.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchDetailsViewController.h"

@implementation SearchTableViewController

@synthesize managedObjectContext;

- (NSFetchedResultsController *)fetchedResultsController
{
	if (!fetchedResultsController)
	{
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"Search" inManagedObjectContext:managedObjectContext]];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hoursWithin" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
 
		fetchedResultsController = [[NSFetchedResultsController alloc]
        	initWithFetchRequest:fetchRequest
        	managedObjectContext:managedObjectContext
        	sectionNameKeyPath:nil
        	cacheName:nil];
		[fetchRequest release];
	}
	return fetchedResultsController;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)initManagedObjectContext
{
	if ((self = [super initWithNibName:@"SearchTableViewController" bundle:nil]))
	{
		managedObjectContext = initManagedObjectContext;
		[[self managedObjectContext] retain];
	}
	return self;
}

- (void)dealloc
{
	[[self managedObjectContext] release];
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
	[self setTitle:@"Search"];
	[[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newSearch:)] autorelease]];
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    [self setClearsSelectionOnViewWillAppear:NO];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self fetchedResultsController] fetchedObjects] count];
}

- (NSManagedObject *)objectForIndexPath:(NSIndexPath *)indexPath
{
	return [[[self fetchedResultsController] fetchedObjects] objectAtIndex:[indexPath row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	#define CELLTYPE_SEARCH @"SearchCell"
	
	UITableViewCell *cell;
    if (!(cell = [tableView dequeueReusableCellWithIdentifier:CELLTYPE_SEARCH]))
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLTYPE_SEARCH] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[[cell textLabel] setText:@"Saved Search"];
	
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[managedObjectContext deleteObject:[self objectForIndexPath:indexPath]];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self isEditing])
	{
		UIViewController *detailsViewController = [[SearchDetailsViewController alloc] initWithRepresentedObject:[self objectForIndexPath:indexPath]];
		[detailsViewController setTitle:@"Edit Search…"];
		[self presentDetailsViewController:detailsViewController];
		[detailsViewController release];
	}
	else
	{
		//... present search results
	}
}

- (IBAction)newSearch:(id)sender
{
	UIViewController *detailsViewController = [[SearchDetailsViewController alloc] initWithManagedObjectContext:[self managedObjectContext]];
	[detailsViewController setTitle:@"New Search…"];
	[self presentDetailsViewController:detailsViewController];
	[detailsViewController release];
}

- (void)presentDetailsViewController:(UIViewController *)detailsViewController
{
	UINavigationController *detailsViewControllerContainer = [[UINavigationController alloc] init];
	[detailsViewControllerContainer pushViewController:detailsViewController animated:NO];
	[[detailsViewController navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(detailsDone:)] autorelease]];
	[[detailsViewController navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(detailsCancel:)] autorelease]];
	[self presentModalViewController:detailsViewControllerContainer animated:YES];
}

- (IBAction)detailsDone:(id)sender
{
	UIViewController *detailsViewControllerContainer = [self modalViewController];
	[self dismissModalViewControllerAnimated:YES];
	[detailsViewControllerContainer release];
}

- (IBAction)detailsCancel:(id)sender
{
	UIViewController *detailsViewControllerContainer = [self modalViewController];
	[self dismissModalViewControllerAnimated:YES];
	[detailsViewControllerContainer release];
}

@end

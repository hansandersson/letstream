//
//  SearchTableViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)initManagedObjectContext;

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSFetchedResultsController *fetchedResultsController;

- (IBAction)newSearch:(id)sender;
- (void)presentDetailsViewController:(UIViewController *)detailsViewController;

- (IBAction)detailsDone:(id)sender;
- (IBAction)detailsCancel:(id)sender;

@end

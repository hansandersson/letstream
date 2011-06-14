//
//  SearchTableViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchTableViewController : UITableViewController
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
}

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSFetchedResultsController *fetchedResultsController;

@end

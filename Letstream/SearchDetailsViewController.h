//
//  SearchDetailsViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchDetailsViewController : UITableViewController {}

- (id)initWithRepresentedObject:(NSManagedObject *)initRepresentedObject;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)initManagedObjectContext;

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObject *representedObject;
@property (readonly) NSArray *sections;
@property (readonly) NSDictionary *sectionObjects;

- (IBAction)tappedAdder:(id)sender;

@end

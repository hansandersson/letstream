//
//  SurveyTableViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SurveyTableViewController : UITableViewController {}

@property (readonly, retain) NSManagedObjectContext *managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)initManagedObjectContext;

@end

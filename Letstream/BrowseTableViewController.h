//
//  BrowseTableViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BrowseTableViewController : UITableViewController {}

@property (readonly, retain) NSArray *sections;
@property (readonly, retain) NSDictionary *sectionObjects;

- (IBAction)tappedAdder:(id)sender;

@end

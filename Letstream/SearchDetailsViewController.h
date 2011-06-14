//
//  SearchDetailsViewController.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchDetailsViewController : UITableViewController {}

@property (readonly, retain) NSArray *sections;
@property (readonly, retain) NSDictionary *sectionObjects;

- (IBAction)tappedAdder:(id)sender;

@end

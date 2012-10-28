//
//  PeoplePicker.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeoplePicker : UITableViewController
{
	NSMutableArray *selectedRecordRefs;
}

- (id)initWithPersonObjects:(NSArray *)initPersonObjects;

@property (readonly) NSArray *personObjects;
@property (readonly) NSArray *selectedObjects;

@end

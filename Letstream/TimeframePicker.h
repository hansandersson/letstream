//
//  TimeframePicker.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/18.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimeframePicker : UITableViewController
{
	NSDictionary *options;
	NSMutableSet *selectedIndexes;
}

@end

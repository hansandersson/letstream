//
//  SearchDetailsSection.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDetailsSection : NSObject {}

- (id)initWithTitle:(NSString *)initTitle representedObjects:(NSArray *)initRepresentedObjects;

- (NSUInteger)rowsCount;

@property (readwrite, copy) NSString *title;
@property (readwrite, retain) NSMutableArray *representedObjects;
@property (readwrite, retain) UIViewController *editViewController;

@end

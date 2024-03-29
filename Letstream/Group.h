//
//  Group.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright (c) 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Record.h"

@class Search;

@interface Group : Record {}

+ (Group *)groupWithName:(NSString *)name insertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSSet *searches;
@property (nonatomic, readonly, copy) NSSet *persons;

@end

//
//  Person.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright (c) 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Record.h"

@interface Person : Record {}

+ (NSArray *)sortedPersonObjects:(NSArray *)personObjects;

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSSet *eventsOwned;
@property (nonatomic, retain) NSSet *eventsInvited;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, readonly, retain) NSSet *groups;

@end

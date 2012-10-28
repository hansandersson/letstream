//
//  Tag.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright (c) 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Tag : NSManagedObject {}

+ (Tag *)tagWithText:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *searches;
@property (nonatomic, retain) NSSet *subtags;
@property (nonatomic, retain) Tag *supertag;

@end

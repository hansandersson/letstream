//
//  Tag.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright (c) 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Tag.h"
#import "Tag.h"


@implementation Tag

+ (Tag *)tagWithText:(NSString *)text inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	Tag *newTag = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Tag" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
	[newTag setValue:text forKey:@"text"];
	return [newTag autorelease];
}

@dynamic text;
@dynamic supertag, subtags;
@dynamic searches;

- (NSString *)description { return [self text]; }

@end

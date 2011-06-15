//
//  SearchDetailsSection.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/15.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "SearchDetailsSection.h"


@implementation SearchDetailsSection

@synthesize representedObjects;
@synthesize title;
@synthesize editViewController;

- (id)initWithTitle:(NSString *)initTitle representedObjects:(NSArray *)initRepresentedObjects
{
	if ((self = [super init]))
	{
		[self setRepresentedObjects:[[initRepresentedObjects mutableCopy] autorelease]];
		[self setTitle:initTitle];
	}
	return self;
}

- (NSUInteger)rowsCount { return [[self representedObjects] count] + (!!editViewController ? 1 : 0); }

- (void)dealloc
{
	[representedObjects release];
	[title release];
	[editViewController release];
	[super dealloc];
}

@end

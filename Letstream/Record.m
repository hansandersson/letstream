//
//  Record.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Record.h"

@implementation Record

- (NSString *)name
{
	if (!name)
	{
		ABAddressBookRef addressBookRef = ABAddressBookCreate();
		name = (NSString *)ABRecordCopyCompositeName(ABAddressBookGetGroupWithRecordID(addressBookRef, [(NSNumber *)[self valueForKey:@"identifier"] intValue]));
		CFRelease(addressBookRef);
	}
	return name;
}

- (NSString *)description { return [self name]; }

- (void)dealloc
{
	[name release];
	[super dealloc];
}

@end

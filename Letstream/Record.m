//
//  Record.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "Record.h"

@implementation Record

@synthesize name, recordRef;

- (NSString *)name
{
	if (!name && [self recordRef])
	{
		ABAddressBookRef addressBookRef = ABAddressBookCreate();
		name = (NSString *)ABRecordCopyCompositeName(recordRef);
		CFRelease(addressBookRef);
	}
	return name;
}

- (ABRecordRef)recordRef { return NULL; }
- (NSString *)description { return [self name]; }

- (void)dealloc
{
	[name release];
	if (recordRefInitialized) CFRelease(recordRef);
	[super dealloc];
}

@end

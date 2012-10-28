//
//  Person.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright (c) 2011 Hans Andersson. All rights reserved.
//

#import "Person.h"
#import "Group.h"

@implementation Person

+ (NSArray *)sortedPersonObjects:(NSArray *)personObjects
{
	NSMutableArray *personObjectsMutable = [[personObjects mutableCopy] autorelease];
	ABAddressBookRef addressBookRef = ABAddressBookCreate();
	
	[personObjectsMutable sortUsingComparator:(NSComparator) ^(Person *person1, Person *person2) {
		ABRecordRef person1Ref = ABAddressBookGetPersonWithRecordID(addressBookRef, [[person1 identifier] intValue]);
		ABRecordRef person2Ref = ABAddressBookGetPersonWithRecordID(addressBookRef, [[person2 identifier] intValue]);
		CFComparisonResult comparisonResult = ABPersonComparePeopleByName(person1Ref, person2Ref, ABPersonGetSortOrdering());
		if (comparisonResult == kCFCompareLessThan) return NSOrderedAscending;
		if (comparisonResult == kCFCompareGreaterThan) return NSOrderedDescending;
		return NSOrderedSame;
	}];
	
	CFRelease(addressBookRef);
	
	return personObjectsMutable;
}

@dynamic identifier, eventsOwned, eventsInvited, comments, groups;

- (ABRecordRef)recordRef
{
	if (!recordRefInitialized)
	{
		ABAddressBookRef addressBookRef = ABAddressBookCreate();
		recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, [(NSNumber *)[self valueForKey:@"identifier"] intValue]);
		CFRetain(recordRef);
		CFRelease(addressBookRef);
		
		recordRefInitialized = YES;
	}
	return recordRef;
}

@end

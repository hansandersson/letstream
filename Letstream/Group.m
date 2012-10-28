//
//  Group.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright (c) 2011 Hans Andersson. All rights reserved.
//

#import "Group.h"
#import "Search.h"
#import <AddressBook/AddressBook.h>

@implementation Group

@dynamic identifier;
@dynamic searches;
@dynamic persons;

+ (Group *)groupWithName:(NSString *)name insertIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	CFErrorRef errorRef = NULL;
	ABAddressBookRef addressBookRef = ABAddressBookCreate();
	ABRecordRef newGroupRef = ABGroupCreate();
	ABRecordSetValue(newGroupRef, kABGroupNameProperty, name, &errorRef);
	if (errorRef)
	{
		NSLog(@"%@", [(NSError *)errorRef localizedDescription]);
		CFRelease(newGroupRef);
		CFRelease(addressBookRef);
		return nil;
	}
	ABAddressBookAddRecord(addressBookRef, newGroupRef, &errorRef);
	if (errorRef)
	{
		NSLog(@"%@", [(NSError *)errorRef localizedDescription]);
		CFRelease(newGroupRef);
		CFRelease(addressBookRef);
		return nil;
	}
	ABAddressBookSave(addressBookRef, &errorRef);
	ABRecordID newGroupID = ABRecordGetRecordID(newGroupRef);
	CFRelease(newGroupRef);
	CFRelease(addressBookRef);
	if (errorRef)
	{
		NSLog(@"%@", [(NSError *)errorRef localizedDescription]);
		return nil;
	}
	
	NSManagedObject *newGroup = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
	[newGroup setValue:[NSNumber numberWithInt:newGroupID] forKey:@"identifier"];
	
	return [newGroup autorelease];
}

- (ABRecordRef)recordRef
{
	if (!recordRefInitialized)
	{
		ABAddressBookRef addressBookRef = ABAddressBookCreate();
		recordRef = ABAddressBookGetGroupWithRecordID(addressBookRef, [(NSNumber *)[self valueForKey:@"identifier"] intValue]);
		CFRetain(recordRef);
		CFRelease(addressBookRef);
		
		recordRefInitialized = YES;
	}
	return recordRef;
}

@end

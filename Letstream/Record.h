//
//  Record.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Record : NSManagedObject
{
	BOOL recordRefInitialized;
	ABRecordRef recordRef;
}

@property (readonly) NSString *name;
@property (readonly) ABRecordRef recordRef;

@end

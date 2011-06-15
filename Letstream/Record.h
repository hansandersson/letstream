//
//  Record.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/14.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Record : NSManagedObject { NSString *name; }

@property (readonly) NSString *name;

@end

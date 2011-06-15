//
//  LetstreamAppDelegate.h
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

void addressBookDidChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context);

@interface LetstreamAppDelegate : NSObject <UIApplicationDelegate>
{
	ABAddressBookRef addressBookRef;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)synchronizeAddressBook;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

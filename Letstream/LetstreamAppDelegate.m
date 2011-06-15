//
//  LetstreamAppDelegate.m
//  Letstream
//
//  Created by Hans Andersson on 11/06/10.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "LetstreamAppDelegate.h"

#import "SurveyTableViewController.h"
#import "SearchTableViewController.h"

void addressBookDidChangeCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) { [(LetstreamAppDelegate *)[[UIApplication sharedApplication] delegate] synchronizeAddressBook]; }

@implementation LetstreamAppDelegate


@synthesize window, tabBarController;
@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	NSLog(@"Universal application:didFinishLaunchingWithOptions:");
	
	for (UINavigationController *navigationController in [tabBarController viewControllers])
	{
		if ([[navigationController title] isEqualToString:@"Survey"]) [navigationController pushViewController:[[[SurveyTableViewController alloc] initWithManagedObjectContext:[self managedObjectContext]] autorelease] animated:NO];
		else if ([[navigationController title] isEqualToString:@"Search"]) [navigationController pushViewController:[[[SearchTableViewController alloc] initWithManagedObjectContext:[self managedObjectContext]] autorelease] animated:NO];
	}
	
	[window addSubview:[tabBarController view]];
	[window makeKeyAndVisible];
	
	//Call subclasses
	[self applicationDidFinishLaunching:application];
	
	addressBookRef = ABAddressBookCreate();
	[self synchronizeAddressBook];
	ABAddressBookRegisterExternalChangeCallback(addressBookRef, addressBookDidChangeCallback, NULL);
    return YES;
}

- (void)synchronizeAddressBook
{
	//GROUPS
	NSArray *groupRefsExternal = [(NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBookRef) autorelease];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:[self managedObjectContext]]];
	NSError *error = nil;
	NSArray *groupsInternal = (NSArray *)[[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error)
	{
		NSLog(@"%@", error);
		return;
	}
	
	NSArray *groupIDsInternal = [groupsInternal valueForKeyPath:@"identifier"];
	NSMutableArray *groupIDsExternal = [NSMutableArray arrayWithCapacity:[groupRefsExternal count]];
	for (id groupRefExternal in groupRefsExternal)
	{
		NSNumber *groupID = [[NSNumber alloc] initWithInt:ABRecordGetRecordID((ABRecordRef)groupRefExternal)];
		[groupIDsExternal addObject:groupID];
		
		if (![groupIDsInternal containsObject:groupID])
		{
			NSManagedObject *newGroup = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
			[newGroup setValue:groupID forKey:@"identifier"];
			[newGroup release];
		}
		
		[groupID release];
	}
	
	for (NSManagedObject *groupInternal in groupsInternal)
	{
		if (![groupIDsExternal containsObject:[groupInternal valueForKey:@"identifier"]]) [[self managedObjectContext] deleteObject:groupInternal];
	}
	
	//PEOPLE
	NSArray *personRefsExternal = [(NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef) autorelease];
	
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]];
	error = nil;
	NSArray *personsInternal = (NSArray *)[[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (error)
	{
		NSLog(@"%@", error);
		return;
	}
	
	NSArray *personIDsInternal = [personsInternal valueForKeyPath:@"identifier"];
	NSMutableArray *personIDsExternal = [NSMutableArray arrayWithCapacity:[personRefsExternal count]];
	for (id personRefExternal in personRefsExternal)
	{
		NSNumber *personID = [[NSNumber alloc] initWithInt:ABRecordGetRecordID((ABRecordRef)personRefExternal)];
		[personIDsExternal addObject:personID];
		
		if (![personIDsInternal containsObject:personID])
		{
			NSManagedObject *newPerson = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
			[newPerson setValue:personID forKey:@"identifier"];
			[newPerson release];
		}
		
		[personID release];
	}
	
	for (NSManagedObject *personInternal in personsInternal)
	{
		if (![personIDsExternal containsObject:[personInternal valueForKey:@"identifier"]]) [[self managedObjectContext] deleteObject:personInternal];
	}
	
	//GROUP MEMBERS
	//...
	
	[self saveContext];
	if (ABAddressBookHasUnsavedChanges(addressBookRef)) ABAddressBookSave(addressBookRef, NULL);
	
	CFRelease(addressBookRef);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
	 //[self synchronizeAddressBook];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	//
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

- (void)dealloc
{
	[window release];
	[tabBarController release];
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	ABAddressBookUnregisterExternalChangeCallback(addressBookRef, addressBookDidChangeCallback, NULL);
	CFRelease(addressBookRef);
	
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
	 */
}

- (void)saveContext
{
    NSError *error = nil;
    if ([self managedObjectContext])
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (!managedObjectContext)
	{
		if ([self persistentStoreCoordinator])
		{
			managedObjectContext = [[NSManagedObjectContext alloc] init];
			[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
		}
	}
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (!managedObjectModel)
	{
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Letstream" withExtension:@"momd"];
    	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!persistentStoreCoordinator)
    {
		NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Letstream.sqlite"];
		
		NSError *error = nil;
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
		{
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 
			 Typical reasons for an error here include:
			 * The persistent store is not accessible;
			 * The schema for the persistent store is incompatible with current managed object model.
			 Check the error message to determine what the actual problem was.
			 
			 
			 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
			 
			 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
			 * Simply deleting the existing store:
			 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
			 
			 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
			 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
			 
			 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
			 
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}    
    }
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

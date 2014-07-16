//
//  SDSyncEngine.m
//  SignificantDates
//
//  Created by Chris Wagner on 7/1/12.
//

#import "SDSyncEngine.h"
#import "SDCoreDataController.h"
#import "SDAFParseAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import <CoreLocation/CoreLocation.h>

NSString * const kSDSyncEngineInitialCompleteKey = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SDSyncEngineSyncCompleted";

@interface SDSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SDSyncEngine

@synthesize syncInProgress = _syncInProgress;

@synthesize registeredClassesToSync = _registeredClassesToSync;
@synthesize dateFormatter = _dateFormatter;

+ (SDSyncEngine *)sharedEngine {
    static SDSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SDSyncEngine alloc] init];
    });
    
    return sharedEngine;
}


+ (CLGeocoder *)getGetCoder {
    static CLGeocoder *geocoder = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        geocoder = [[CLGeocoder alloc] init];
    });
    
    return geocoder;
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {        
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            NSLog(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
        }
    } else {
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
    }
}
- (void)resetRegistration
{
    self.registeredClassesToSync = nil;
}
- (void)registerStringToSync:(NSString *)sClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if (![self.registeredClassesToSync containsObject:sClass])
    {
        [self.registeredClassesToSync addObject:sClass];
    }
    else
    {
            NSLog(@"Unable to register %@ as it is already registered",sClass);
    }
    
}
- (void)startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
          NSLog(@"sync in progress");
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES];
        });
    }
    else
    {
        NSLog(@"SYNCH ALREADY IN PROGRESS");
    }
}

- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        NSError *error = nil;
        [[SDCoreDataController sharedInstance] saveBackgroundContext];
        if (error) {
            NSLog(@"Error saving background context after creating objects on server: %@", error);
        }
        
        [[SDCoreDataController sharedInstance] saveMasterContext];
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:kSDSyncEngineSyncCompletedNotificationName 
         object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
        NSLog(@"sync complete");
    });
}


- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    [request setFetchLimit:1];
    [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[SDCoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    NSInteger month = [components month];
//    
//    
//    NSLog(@"most recent update date is ->'%@' and month is %d",date, month  );
    return date;
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate {
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        
        NSString *parseClassName = [className componentsSeparatedByString:@";"][1];
        NSString *localClassName = [className componentsSeparatedByString:@";"][0];
        NSLog(@"parse class name is %@ and local classname is %@", parseClassName, localClassName);
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:localClassName];
        }
        NSMutableURLRequest *request = [[SDAFParseAPIClient sharedClient] 
                                        GETRequestForAllRecordsOfClass:parseClassName
                                        updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[SDAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self writeJSONResponse:responseObject toDiskForClassWithName:parseClassName];
            }            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request for class %@ failed with error: %@", className, error);
        }];
        
        [operations addObject:operation];
    }
    NSLog(@"SENDING HTTP REQUEST ");
    [[SDAFParseAPIClient sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {

        if (useUpdatedAtDate) {
            NSLog(@"use updatedatdate value:");
            [self processJSONDataRecordsIntoCoreData];
        }
  
        else {
                NSLog(@"DO NOT use updatedatdate value:");
               // [self processJSONDataRecordsForDeletion];
        }
    }];
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSLog(@"number of classes registered for sync are %ld",(unsigned long)[self.registeredClassesToSync count]);
    for (NSString *className in self.registeredClassesToSync)
    {
        NSString *parseClassName = [className componentsSeparatedByString:@";"][1];
        NSString *localClassName = [className componentsSeparatedByString:@";"][0];
        NSLog(@"parse class name is %@ and local classname is %@", parseClassName, localClassName);
        
        if (![self initialSyncComplete])
        { // import all downloaded data to Core Data for initial sync
            NSLog(@"importing data for initial sync since initial sync not complete");
            
            NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:parseClassName];
            NSArray *records = [JSONDictionary objectForKey:@"results"];
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:localClassName forRecord:record];
            }
        }
        else
        {
            NSLog(@"importing data for initial sync  ");

            NSArray *downloadedRecords = [self JSONDataRecordsForClass:parseClassName sortedByKey:@"objectId"];
            NSLog(@"downloaded records are %lu",(unsigned long)[downloadedRecords count]);
            
            
            if ([downloadedRecords lastObject]) {
                NSArray *storedRecords = [self managedObjectsForClass:localClassName sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    if ([storedRecords count] > currentIndex) {
                        storedManagedObject = [storedRecords objectAtIndex:currentIndex];
                    }
                    
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        [self updateManagedObject:[storedRecords objectAtIndex:currentIndex] withRecord:record];
                    } else {
                        [self newManagedObjectWithClassName:localClassName forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save context for class %@", className);
            }
        }];
        
        [self deleteJSONDataRecordsForClassWithName:parseClassName];
        [self executeSyncCompletedOperations];
    }
    
    [self downloadDataForRegisteredObjects:NO];
}

- (void)newManagedObjectWithClassName:(NSString *)className forRecord:(NSDictionary *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[SDCoreDataController sharedInstance] backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    
    
//    NSString *address =[record objectForKey:@"address"];
//    NSString *city =[record objectForKey:@"city"];
//    NSString *zip =[record objectForKey:@"zip"];
//    NSString *fulladdress = [NSString stringWithFormat:@"%@ %@ %@",address, city, zip];
//  
//   // dispatch_queue_t myCustomQueue;
//   // myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
//    CLGeocoder *g = [SDSyncEngine getGetCoder];
//    
//   // dispatch_sync(myCustomQueue, ^{
//    
//    
//    
//        [g geocodeAddressString:fulladdress completionHandler: ^(NSArray *placemarks, NSError *error) {
//            //3
//            if ([placemarks count]>0) { //4
//                CLPlacemark* mark = (CLPlacemark*)placemarks[0];
//                double lat = 0.0;
//                double lng = 0.0;
//                
//                
//                lat = mark.location.coordinate.latitude;
//                lng = mark.location.coordinate.longitude;
//                //5 show the coords text
//                //      _locationLabel.text = [NSString stringWithFormat: @"Cordinate\nlat: %@, long: %@",
//                //                           [NSNumber numberWithDouble: lat], [NSNumber numberWithDouble: lng]];
//                //show on the map
//                [record setValue:[NSNumber numberWithInt:lat] forKey:@"latitude"];
//                [record setValue:[NSNumber numberWithInt:lng] forKey:@"longitude"];
//                [record setValue:[NSNumber numberWithInt:SDObjectSynced] forKey:@"syncStatus"];
//                
//                
//                //1
//            }
//        }];
//        
//        sleep(60);
//    
//    
    
    
    //});
    
    
    //2
    
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else {
        //NSLog(@"key is %@ and value is %@", key, value);
        NSRange range = [key rangeOfString:@"price" options:NSCaseInsensitiveSearch];
        
        // What did we find
        if (range.length > 0)
        {
            
            key = [key lowercaseString];
            //NSLog(@"key changed to %@", key);
        }
        [managedObject setValue:value forKey:key];
    }
}

- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(SDObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;    
}

- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SDCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    // NSDateFormatter does not like ISO 8601 so strip the milliseconds and timezone
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000Z"];
    
    return dateString;
}

#pragma mark - File Management

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return url;
}

- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className {
    //NSLog(@"response is %@ for classname %@",response, className);
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // remove NSNulls and try again...
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES]) {
            NSLog(@"Failed all attempts to save reponse to disk: %@", response);
        }
    }
}

- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        NSLog(@"Unable to delete JSON Records at %@, reason: %@", url, error);
    }
}

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]]; 
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}

- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key {
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                 [NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]];
}
@end

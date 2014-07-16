//
//  SDSyncEngine.h
//  SignificantDates
//
//  Created by Chris Wagner on 7/1/12.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum {
    SDObjectSynced = 0,
} SDObjectSyncStatus;

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine *)sharedEngine;
+ (CLGeocoder *)geocoder;


- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)registerStringToSync:(NSString *)sClass;
- (void)startSync;
- (void)resetRegistration;
@end

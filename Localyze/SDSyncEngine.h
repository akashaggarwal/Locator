//
//  SDSyncEngine.h
//  SignificantDates
//
//  Created by Corneliu Chitanu on 29/04/14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    SDObjectSynced = 0,
    SDObjectCreated,
    SDObjectDeleted,
} SDObjectSyncStatus;

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;
//@property (nonatomic) double nearest;
//@property (nonatomic) double farthest;
//@property (nonatomic) BOOL showZipOption;
+ (SDSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;
- (void)registerStringToSync:(NSString *)sClass;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

- (void)resetRegistration;
@end

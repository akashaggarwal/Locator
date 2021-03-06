//
//  OhioData.h
//  StoreLocator
//
//  Created by Akash Aggarwal on 5/6/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OhioData : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * agencyname;
@property (nonatomic, retain) NSString * agencynumber;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * classtype;
@property (nonatomic, retain) NSString * county;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * dba;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * originalissuedate;
@property (nonatomic, retain) NSString * permitnumber;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * sundaysales;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * taxrate;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * distanceFromCurrent;

@end

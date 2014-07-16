//
//  Model.h
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//



@interface Model : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* location;
@property (nonatomic, copy) NSString* zipCode;
@property (nonatomic, copy) NSString* distance;
@property (nonatomic, copy) NSString* distanceMetric;
@property (nonatomic, copy) NSString* paidType;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

+ (id)modelWithDict:(NSDictionary *)dict;

@end

//
//  Model.m
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (id)modelWithDict:(NSDictionary *)dict {
    Model *item = [[Model alloc] init];
        item.title = dict[@"title"];
        item.location = dict[@"location"];
        item.zipCode = dict[@"zipCode"];
        item.distanceMetric = dict[@"distanceMetric"];
        item.distance = dict[@"distance"];
        item.paidType = dict[@"paidType"];
        item.latitude = [dict[@"latitude"] doubleValue];
        item.longitude = [dict[@"longitude"] doubleValue];
    
    return item;
}


@end

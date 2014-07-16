//
//  DataLoader.m
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "DataLoader.h"
#import "Model.h"

@implementation DataLoader


+ (NSArray *)locations {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
    NSArray *rawItems = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:rawItems.count];
    
    for (NSDictionary *item in rawItems) {
        [items addObject:[Model modelWithDict:item]];
    }
    
    return items;
}

@end

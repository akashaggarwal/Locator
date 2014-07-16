//
//  StoreAnnotation.h
//  StorePlotter
//
//  Created by Akash Aggarwal on 12/7/12.
//  Copyright (c) 2012 Akash Aggarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface StoreAnnotation : NSObject<MKAnnotation>


-(id)initWithCoordinate:(CLLocationCoordinate2D)c;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end

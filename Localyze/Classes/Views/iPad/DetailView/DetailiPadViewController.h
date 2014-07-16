//
//  MasterViewController.h
//  Localyze
//
//  Created by Valentin Filip on 09/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import <MapKit/MapKit.h>


@interface DetailiPadViewController : UIViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceMetricLabel;
@property (nonatomic, strong) IBOutlet UILabel *paidTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *nearestLabel;
@property (nonatomic, strong) IBOutlet UILabel *furthestLabel;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIImageView *detailBackground;


@property (nonatomic, strong) Model* item;


@end
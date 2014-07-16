//
//  DetailThemeController.h
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Model.h"
#import "AgencyData.h"

@interface DetailViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, retain) Model* model;
@property (nonatomic, retain) AgencyData* liqormodel;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* locationLabel;
@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* distanceMetricLabel;
@property (nonatomic, strong) IBOutlet UILabel* paidTypeLabel;
//@property (nonatomic, strong) IBOutlet UILabel* zipCodeLabel;
@property (nonatomic, strong) IBOutlet UILabel* nearestLabel;
@property (nonatomic, strong) IBOutlet UILabel* furthestLabel;

@property (nonatomic, strong) IBOutlet MKMapView* mapView;

@property (strong, nonatomic) IBOutlet UIButton *buttonAddLocation;

- (IBAction)actionClose:(id)sender;
- (IBAction)phoneclicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *phonebutton;

@end

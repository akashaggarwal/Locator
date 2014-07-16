//
//  DetailThemeController.m
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "DetailViewController.h"
#import "Annotation.h"
#import "AppDelegate.h"
#import "StoreAnnotation.h"
#import "BrandsViewController.h"
#import "SDSyncEngine.h"
#import "OhioBrandData.h"

@implementation DetailViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    
    _nearestLabel.text = @"0.43";
    _furthestLabel.text = @"4.34";
    
    NSString *dbaname = _liqormodel.dba;
    if ([dbaname hasPrefix:@"DBA"] || [dbaname hasPrefix:@"dba"])
        dbaname = [dbaname substringFromIndex:3];

    _titleLabel.text = dbaname;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:17];
    
    NSString *address = [NSString stringWithFormat:@"%@\n%@ OH %@",_liqormodel.address, _liqormodel.city, _liqormodel.zip];
    
    _locationLabel.text = address;
    _locationLabel.textColor = [UIColor colorWithRed:0.85f green:0.86f blue:0.87f alpha:1.00f];
    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    NSLog([NSString stringWithFormat:@"tel:%@",_liqormodel.phone]);

    [_phonebutton setTitle:_liqormodel.phone forState:UIControlStateNormal] ;
    _phonebutton.titleLabel.textColor = [UIColor whiteColor];
    _phonebutton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    _paidTypeLabel.text = [_liqormodel.sundaysales uppercaseString];
    _paidTypeLabel.font = [UIFont fontWithName:@"DINPro-Medium" size:12];
    
    _distanceMetricLabel.text = [@"mi" lowercaseString];
    _distanceMetricLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _distanceMetricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_liqormodel.distanceFromCurrent.doubleValue];
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Th" size:17];
    
    
    float latitude = [[_liqormodel.location componentsSeparatedByString:@","][0] floatValue];
    float longitude = [[_liqormodel.location componentsSeparatedByString:@","][1] floatValue];
    
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = latitude;
    coordinate1.longitude = longitude;
   StoreAnnotation *annotation = [[StoreAnnotation alloc] initWithName:dbaname address:address coordinate:coordinate1] ;
    
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    
  //  Annotation *annotation = [[Annotation alloc] initWithLatitude:latitude andLongitude:longitude];
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateRegion region;
//    float latitude = latitude;
//    float longitude =longitude;
//    
    region.span.latitudeDelta=1.0/69*0.5;
    region.span.longitudeDelta=1.0/69*0.5;
    
    region.center.latitude=latitude;
    region.center.longitude=longitude;
    
    [_mapView setRegion:region animated:YES];
    [_mapView regionThatFits:region];
    
    _buttonAddLocation.titleLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:12];
    [_buttonAddLocation setTitleColor:[UIColor colorWithRed:0.53f green:0.54f blue:0.57f alpha:1.00f] forState:UIControlStateNormal];
    
}



- (void)callWithString:(NSString *)phoneString
{
    [self callWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneString]]];
}
- (void)callWithURL:(NSURL *)url
{
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)phoneclicked:(id)sender {
    NSLog(@"clicked");
    [self callWithString:[sender titleForState:UIControlStateNormal]];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
    
    
    if ([annotation isKindOfClass:[StoreAnnotation class]])
    {
         NSLog(@"store annotation found");
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            NSLog(@"annotation view is null");
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:@"bottle.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
       return nil;
    
}



// Add the following method
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"callout");
    StoreAnnotation *location = (StoreAnnotation*)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowBrands"])
    {
        NSString *dynamicAgency = [NSString stringWithFormat:@"OhioBrandData;A%@",_liqormodel.agencynumber];
        NSLog(dynamicAgency);
         BrandsViewController *brandsViewController = [segue destinationViewController];
        brandsViewController.agencyCode = _liqormodel.agencynumber;
        brandsViewController.agencyName = _liqormodel.dba;
         NSLog(@" SEQUE TO Agency code is %@ and name is %@",  _liqormodel.agencynumber,_liqormodel.dba);
        
        
        //  [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[OhioBrandData class]];
        
           [[SDSyncEngine sharedEngine] resetRegistration];
        [[SDSyncEngine sharedEngine] registerStringToSync:dynamicAgency];
        [[SDSyncEngine sharedEngine] startSync];
        //         UIOldMeterViewController *oldViewController = (UITabBarController *)[[segue.destinationViewController viewControllers] objectAtIndex:0];
        //         oldViewController.currentclaim = self.currentclaim;
    }
}

//- (IBAction)unwindSegue:(UIStoryboardSegue *)segue {
//    NSLog(@" came from brands");
//}

@end

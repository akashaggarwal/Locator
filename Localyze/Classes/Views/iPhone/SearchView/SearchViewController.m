//
//  SearchViewController.m
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 120

#import "SearchViewController.h"
#import "SDSyncEngine.h"
#import "SDCoreDataController.h"
#import "AppDelegate.h"

@interface SearchViewController ()
{
    
    CLLocationManager *manager ;
    CLLocationCoordinate2D currentcoordinate ;
    bool showZipOption ;
}
@end

@implementation SearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:28];
    
//    _alternativeLabel.textColor = [UIColor colorWithRed:0.52f green:0.55f blue:0.56f alpha:1.00f];
//    _alternativeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15];
//    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    _textField.leftView = paddingView;
//    _textField.leftViewMode = UITextFieldViewModeAlways;
//    
//    _textField.font = [UIFont fontWithName:@"Avenir-Black" size:15];
//    
//    _textField.returnKeyType = UIReturnKeyDone;
//    
    //_searchButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:17];
   // [_searchButton setTitleColor:[UIColor colorWithRed:0.63f green:0.64f blue:0.69f alpha:1.00f] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
    
    
          
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
//    gesture.delegate = self;
//    [self.view addGestureRecognizer:gesture];
    
    [self startStandardUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
  
    //      name:UIKeyboardWillShowNotification object:self.view.window];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(onSlashScreenDone) userInfo:nil repeats:NO];
    
  
    
}

-(void)onSlashScreenDone{
   
    NSLog(@"zip option is %d", showZipOption);
    if (showZipOption)
        [self performSegueWithIdentifier:@"showZip" sender:self];
    else
        [self performSegueWithIdentifier:@"showLocations" sender:self];
}

-(void) startStandardUpdates
{
    if (nil == manager)
    {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        //manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        //manager.distanceFilter = 500;
        [manager startUpdatingLocation];
    }
    
    
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == manager)
    {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        // manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        //manager.distanceFilter = 500;
        [manager startMonitoringSignificantLocationChanges];
        
    }
}
//deprecated
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    // NSLog(@"got new signal");
//    if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude)
//        
//    {
//        //    NSLog(@"using ios5 latitude %+.6f, longitude %+.6f\n",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//        
//        [self revGeocode: newLocation];
//        
//    }
//}
//ios6 sends didupdatelocations
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    //    // If it's a relatively recent event, turn off updates to save power
    
    // NSLog(@"got new signal");
    
    CLLocation* newlocation = [locations lastObject];
     //NSLog(@"using ios6 latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude,location.coordinate.longitude);
    
    CLLocationCoordinate2D lastlocation = [[AppDelegate sharedDelegate] currentcoordinate];
    if (newlocation.coordinate.latitude != lastlocation.latitude || newlocation.coordinate.longitude != lastlocation.longitude)
    {
         [self revGeocode: newlocation];
    }
    
    //[self revGeocode: location];
//    
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    NSLog(@"%d",abs(howRecent));
//    if (abs(howRecent) < 5.0)
//    {
//            NSLog(@"got new signal AND BEEN 5 SECONDS");
//            // If the event is recent, do something with it.
//            NSLog(@"using ios6 latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude,location.coordinate.longitude);
//        [self revGeocode: location];
//    }
}

-(void)revGeocode:(CLLocation*)c {
    //reverse geocoding demo, coordinates to an address
    //_addressLabel.text = @"reverse geocoding coordinate ...";
    currentcoordinate = c.coordinate;
    //  NSLog(@"current coordinate is %f, %f", currentcoordinate.latitude, currentcoordinate.longitude);
    [[AppDelegate sharedDelegate] setCurrentcoordinate:currentcoordinate];
    
    
}


- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    showZipOption = true;
    //[SDSyncEngine sharedEngine].showZipOption = showZipOption;
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
          //  [alert release];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
          //  [alert release];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
          //  [alert release];
        }
            break;
    }
}





- (void)viewWillDisappear:(BOOL)animated {
   // [manager stopUpdatingLocation];

    // unregister for keyboard notifications while not visible.
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
   // self.textField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

//- (IBAction)actionSearch:(id)sender {
//    [self.view endEditing:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)actionClose:(id)sender {
//    [self.view endEditing:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//
//#pragma mark - UIGestureRecognizer delegate
//
//- (void)didTapView:(UIGestureRecognizer *)recognizer {
//    [self.view endEditing:YES];
//    if (![_textField isFirstResponder] && self.view.frame.origin.y < 0) {
//        [self setViewMovedUp:NO];
//    }
//}
//
//
//#pragma mark - UITextField delegate
//
//
//-(void)textFieldDidBeginEditing:(UITextField *)sender {
//    if ([sender isEqual:_textField]) {
//        if  (self.view.frame.origin.y >= 0) {
//            [self setViewMovedUp:YES];
//        }
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self actionSearch:nil];
//    
//    return NO;
//}
//
//
//#pragma mark - Keyboard handler
//
//- (void)keyboardWillShow:(NSNotification *)notif {
//    if ([_textField isFirstResponder] && self.view.frame.origin.y >= 0) {
//        [self setViewMovedUp:YES];
//    } else if (![_textField isFirstResponder] && self.view.frame.origin.y < 0) {
//        [self setViewMovedUp:NO];
//    }
//}
//
//
//- (void)setViewMovedUp:(BOOL)movedUp {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
//    
//    CGRect rect = self.view.frame;
//    if (movedUp) {
//        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
//        // 2. increase the size of the view so that the area behind the keyboard is covered up.
//        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
//        rect.size.height += kOFFSET_FOR_KEYBOARD;
//    } else {
//        // revert back to the normal state.
//        rect.origin.y += kOFFSET_FOR_KEYBOARD;
//        rect.size.height -= kOFFSET_FOR_KEYBOARD;
//    }
//    self.view.frame = rect;
//    
//    [UIView commitAnimations];
//}




@end

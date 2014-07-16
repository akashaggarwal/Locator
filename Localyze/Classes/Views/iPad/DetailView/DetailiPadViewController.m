//
//  MasterViewController.m
//  Localyze
//
//  Created by Valentin Filip on 09/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DetailiPadViewController.h"
#import "MasterCell.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "Annotation.h"
#import "ThemeListCell.h"
#import "KSCustomPopoverBackgroundView.h"
#import "ADVTheme.h"

@interface DetailiPadViewController ()

@property (nonatomic, strong) UIPopoverController *popoverController;

@end




@implementation DetailiPadViewController

@synthesize popoverController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    _detailBackground.image = [[UIImage imageNamed:@"map-details"] resizableImageWithCapInsets:(UIEdgeInsets){0, 10, 0, 200}];
    
    [self configurePopup];
    [self customizeTabs];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Accessors

- (void)setItem:(Model *)item {
    if ([_item isEqual:item]) {
        return;
    }
    
    _item = item;
    [self loadDataIntoView:item];
}


#pragma mark - Actions

- (void)showPopover:(id)sender {
    UIBarButtonItem* senderButton = (UIBarButtonItem *)sender;
    
    if (self.popoverController) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    
    self.popoverController = [[UIPopoverController alloc]
                              initWithContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PopoverVC"]];
    popoverController.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
    
    popoverController.delegate = self;
    [popoverController presentPopoverFromBarButtonItem:senderButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}



#pragma mark - Visual stuff

-(void)loadDataIntoView:(Model*)model {
    
    _nearestLabel.text = @"0.43";
    _furthestLabel.text = @"4.34";
    
    _titleLabel.text = model.title;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Roman" size:22];
    
    _locationLabel.text = model.location;
    _locationLabel.textColor = [UIColor colorWithRed:0.85f green:0.86f blue:0.87f alpha:1.00f];
    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    _zipCodeLabel.text = model.zipCode;
    _zipCodeLabel.textColor = [UIColor whiteColor];
    _zipCodeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    
    _paidTypeLabel.text = [model.paidType uppercaseString];
    _paidTypeLabel.font = [UIFont fontWithName:@"DINPro-Medium" size:17];
    
    _distanceMetricLabel.text = [model.distanceMetric uppercaseString];
    _distanceMetricLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _distanceMetricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    
    _distanceLabel.text = model.distance;
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Th" size:26];
    
    Annotation *annotation = [[Annotation alloc] initWithLatitude:model.latitude andLongitude:model.longitude];
    
    [_mapView addAnnotation:annotation];
    
    MKCoordinateRegion region;
    float latitude = model.latitude;
    float longitude = model.longitude;
    
    region.span.latitudeDelta=1.0/69*0.5;
    region.span.longitudeDelta=1.0/69*0.5;
    
    region.center.latitude=latitude;
    region.center.longitude=longitude;
    
    [_mapView setRegion:region animated:YES];
    [_mapView regionThatFits:region];  
    
}

- (void)configurePopup {
    UIBarButtonItem *btnPopup = [[UIBarButtonItem alloc] initWithTitle:@"Popover" style:UIBarButtonItemStylePlain target:self action:@selector(showPopover:)];
    
    UITabBarController *tabBarC = ((UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController);
    UINavigationController *nav = tabBarC.viewControllers[0];
    UIViewController *childVC = nav.viewControllers[0];
    childVC.navigationItem.rightBarButtonItem = btnPopup;
}

- (void)customizeTabs {
    UITabBarController *tabBarC = ((UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController);
    UINavigationController *nav = tabBarC.viewControllers[0];
    
    NSArray *items = nav.tabBarController.tabBar.items;
    for (int idx = 0; idx < items.count; idx++) {
        UITabBarItem *item = items[idx];
        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
    }
}

#pragma mark - UIPopover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
    }
}


@end

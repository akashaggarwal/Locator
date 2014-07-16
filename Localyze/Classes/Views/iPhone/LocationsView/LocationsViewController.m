//
//  LocationsViewController.m
//  Localyse
//
//  Created by Valentin Filip on 18/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "LocationsViewController.h"
#import "ThemeListCell.h"
#import "DataLoader.h"
#import "Model.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ADVAnimationController.h"
#import "DropAnimationController.h"
#import "ZoomAnimationController.h"
#import "SliceAnimationController.h"





#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "AgencyData.h"

@interface LocationsViewController () {
    UIColor *startColor;
    UIColor *endColor;
    double lowest;
    double highest ;
    
    
   }

@property (nonatomic, strong) id<ADVAnimationController> animationController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end



@implementation LocationsViewController

@synthesize tableListView, models, furthestLabel, nearestLabel;


@synthesize dateFormatter;
@synthesize managedObjectContext;

@synthesize entityName;
@synthesize refreshButton;
@synthesize data;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.models = [DataLoader locations];
    
    //[[SDSyncEngine sharedEngine] registerStringToSync:@"AgencyData;AgencyData"];
    //[[SDSyncEngine sharedEngine] startSync];
    
    
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    [tableListView setBackgroundColor:[UIColor clearColor]];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    startColor = [UIColor colorWithRed:0.93f green:0.73f blue:0.20f alpha:1.00f];
    endColor = [UIColor colorWithRed:0.25f green:0.83f blue:0.71f alpha:1.00f];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
    _buttonAddLocation.titleLabel.font = [UIFont fontWithName:@"DINPro-Bold" size:12];
    [_buttonAddLocation setTitleColor:[UIColor colorWithRed:0.53f green:0.54f blue:0.57f alpha:1.00f] forState:UIControlStateNormal];
    
//    self.animationController = [[ZoomAnimationController alloc] init];
    self.animationController = [[DropAnimationController alloc] init];
//    self.animationController = [[SliceAnimationController alloc] init];
    
    
    
    
    
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self loadRecordsFromCoreData];
    
    
    [nearestLabel setText:[NSString stringWithFormat:@"%.2f",lowest]];
    [furthestLabel setText:[NSString stringWithFormat:@"%.2f",highest]];
    
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
   // [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Table View datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LocationCell";

    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGFloat step = 1.0 / (self.sorteddata.count /*> 10 ? models.count : 10*/);
    UIColor *start = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-indexPath.row*step];
    UIColor *end = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-(indexPath.row+1)*(step*1.1)];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[AppDelegate createGradientImageFromColor:start toColor:end withSize:cell.bounds.size] ];
        
//    Model* model = models[indexPath.row];
//    cell.model = model;
//    
    AgencyData *myData = [self.sorteddata objectAtIndex:indexPath.row];
    cell.liqormodel = myData;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sorteddata count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNav"];
    nav.transitioningDelegate = self;
    
    DetailViewController *controller = nav.viewControllers[0];
    controller.liqormodel = self.sorteddata[tableListView.indexPathForSelectedRow.row];
    
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}





- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"dba" ascending:YES]]];
        self.data = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        CLLocationCoordinate2D currentLocation = [[AppDelegate sharedDelegate] currentcoordinate];
        CLLocation *current = [[CLLocation alloc]initWithLatitude:currentLocation.latitude
                               
                                                        longitude:currentLocation.longitude];
        NSMutableArray *sortedrecords = [[NSMutableArray alloc]init];
        CLLocation *temp = nil;
        
        for(AgencyData *o in self.data)
        {
            double latitude = [[o.location componentsSeparatedByString:@","][0] doubleValue];
            double longitude = [[o.location componentsSeparatedByString:@","][1] doubleValue];
            
            temp = [[CLLocation alloc]initWithLatitude:latitude
                                             longitude:longitude];
            CLLocationDistance meters = [current   distanceFromLocation:temp];
            
            double miles = meters * 0.000621371192;
            if (meters > highest)
                highest = meters;
            
            if (meters < lowest || lowest == 0)
                lowest = meters;
            
            o.distanceFromCurrent = [NSNumber numberWithDouble:miles] ;
            
           // NSLog(@"store name %@ %@ and distance %.2f",o.agencyname, o.dba, miles);
        }
        lowest = lowest * 0.000621371192 ;
        highest  =highest * 0.000621371192;
       // NSLog(@"closest is %f and farthest is %f and total stores are %lu",lowest, highest, (unsigned long)self.data.count);
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distanceFromCurrent" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        self.sorteddata = [self.data sortedArrayUsingDescriptors:sortDescriptors];
        
        
    }];
}


- (IBAction)refreshButtonClicked:(id)sender {
      [[SDSyncEngine sharedEngine] startSync];
}


- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButon];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButon {
    self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableListView reloadData];
        [self checkSyncStatus];
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

@end

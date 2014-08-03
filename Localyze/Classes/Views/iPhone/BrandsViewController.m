//
//  LocationsViewController.m
//  Localyse
//
//  Created by Valentin Filip on 18/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "BrandsViewController.h"
#import "BrandListCell.h"
#import "DataLoader.h"
#import "Model.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ADVAnimationController.h"
#import "DropAnimationController.h"
#import "ZoomAnimationController.h"
#import "SliceAnimationController.h"

#import <QuartzCore/QuartzCore.h>



#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "OhioBrandData.h"

@interface BrandsViewController () {
    UIColor *startColor;
    UIColor *endColor;
    double lowest;
    double highest ;
   // int numberoftries  ;
    
}

@property (nonatomic, strong) id<ADVAnimationController> animationController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



//@property(nonatomic, strong) UISearchBar *searchBar;
//@property(nonatomic, strong) UISearchDisplayController *searchController;

@property(nonatomic,strong) NSMutableArray *searchResults;

@end



@implementation BrandsViewController

@synthesize tableListView;


@synthesize dateFormatter;
@synthesize managedObjectContext;

@synthesize entityName;
@synthesize refreshButton;
@synthesize data;
@synthesize agencyCode;
@synthesize agencyName;
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [tableListView setDelegate:self];
    [tableListView setDataSource:self];
    
    [tableListView setBackgroundColor:[UIColor clearColor]];
    [tableListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    startColor = [UIColor colorWithRed:0.93f green:0.73f blue:0.20f alpha:1.00f];
    endColor = [UIColor colorWithRed:0.25f green:0.83f blue:0.71f alpha:1.00f];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    

    self.animationController = [[DropAnimationController alloc] init];
    
    
    
    
    
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
   // [self loadRecordsFromCoreData];
    //self.navigationItem.title = self.agencyName;
    [self settitleBar:self.agencyName secondLineText:nil];
    
 //   [self loadRecordsFromCoreData];
//    [self setupSearchBar];
    self.searchResults = [NSMutableArray array];
   // self.automaticallyAdjustsScrollViewInsets = NO;
   // numberoftries = 0;
    
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

-(void) settitleBar:(NSString *) text
                            secondLineText:(NSString *)text2
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    if ([text2 length] > 0)
        label.numberOfLines = 2;
    else
        label.numberOfLines = 1;
    NSLog(@"length is %d",[text length]);
    if ([text length] > 25 )
        label.font = [UIFont boldSystemFontOfSize: 11.0f];
    else
        label.font = [UIFont boldSystemFontOfSize: 14.0f];
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
     if ([text2 length] > 0)
         label.text = [NSString stringWithFormat:@"%@\n%@", text, text2];
     else
         label.text = text;
    
    self.navigationItem.titleView = label;
}
- (void)viewWillAppear:(BOOL)animated {
    // [self.navigationController setNavigationBarHidden:NO];
//    NSLog(@"search bar frame height is %f ",self.searchBar.frame.size.height );
//    CGPoint offset = CGPointMake(0, -(self.searchBar.frame.size.height) );
//    self.tableListView.contentOffset = offset ;
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) retry
{
    [[SDSyncEngine sharedEngine] startSync];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
   [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableListView reloadData];
       // numberoftries ++;
//       NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:9.0],UITextAttributeFont,
//                             [UIColor whiteColor],  NSForegroundColorAttributeName,
//                             nil];
//        //NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
//          //                                                                     fontWithName:@"Arial" size:8.0], NSFontAttributeName,
//         //                           [UIColor whiteColor], NSForegroundColorAttributeName, nil];
//        
//        //[[UINavigationBar appearance] setTitleTextAttributes:attributes];
//        self.navigationController.navigationBar.titleTextAttributes = size;
        NSString *titletext = nil;
        
//        if ([self.data count] == 0 && numberoftries < 3)
//         {
//             NSLog(@"retrying loading of data try number %d", numberoftries);
//             titletext = [NSString stringWithFormat:@"Retrying....try number %d",numberoftries];
//             [self settitleBar:titletext secondLineText:nil];
//             [self retry];
//         }
//        else if ([self.data count] == 0 && numberoftries >= 3)
//        {
//           titletext = [NSString stringWithFormat:@"We are not able to load the data, please try again by clicking Refresh buttton on right"];
//            [self settitleBar:titletext secondLineText:nil];
//        }
        if ([self.data count] == 0 )
        {
            titletext = [NSString stringWithFormat:@"Unable to Load, Click Refresh for Retry"];
                        [self settitleBar:titletext secondLineText:nil];
        }
        else
        {
            if ([self.data count] == 1000)
                [self settitleBar: self.agencyName secondLineText:@"(Top 1000 brands only)"];
            
            else
                [self settitleBar: self.agencyName secondLineText:[NSString stringWithFormat:@"(%d brands)",[self.data count]]];
          
            
        }
        
        
        
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}


//- (void)setupSearchBar {
//    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    self.tableListView.tableHeaderView = self.searchBar;
//    
//    // scroll just past the search bar initially
//   
////
//    // scroll just past the search bar initially
//    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
//    self.tableListView.contentOffset = offset;
//    
//    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
//                                                              contentsController:self];
//    self.searchController.searchResultsDataSource = self;
//    self.searchController.searchResultsDelegate = self;
//    self.searchController.delegate = self;
//}




- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"search string is %@", searchString);
    [self filterProductsForTerm:searchString];
    return YES;
}

- (void)filterProductsForTerm:(NSString *)term {
    
   // [self.searchResults removeAllObjects];
     self.searchResults = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brandname contains[cd] %@", term];
    NSArray *results = [self.sorteddata filteredArrayUsingPredicate:predicate];
    NSLog(@"filtered text is %@ and count is ->%lu", term, (unsigned long)[results count]);

    [self.searchResults addObjectsFromArray:results];
}


#pragma mark - Table View datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BrandCell";
    
    BrandListCell *cell = (BrandListCell *)[self.tableListView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (cell == nil)
//    {
//        //cell = [BrandListCell  alloc] in
//       // cell = [[BrandListCell  alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
//        cell = [[CustomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        
//        NSLog(@"iinitializing cell");
//
//    }
// 
//    int radius = 8;
//    cell.BRetailLabel.layer.cornerRadius = radius;
//   cell.MRetailLabel.layer.cornerRadius = radius;
//    cell.ERetailLabel.layer.cornerRadius = radius;
//    cell.LRetailLabel.layer.cornerRadius = radius;
//    
//    cell.DRetailLabel.layer.cornerRadius = radius;
//    
//    
//    
//    cell.BWholeSaleLabel.layer.cornerRadius = radius;
//    cell.MWholeSaleLabel.layer.cornerRadius = radius;
//    cell.EWholeSaleLabel.layer.cornerRadius = radius;
//    
//    cell.LWholeSaleLabel.layer.cornerRadius = radius;
//    
//    cell.DWholeSaleLabel.layer.cornerRadius = radius;
//
//    / Huge change in performance by explicitly setting the below (even though default is supposedly NO)
//    lbl.layer.masksToBounds = NO;
//    // Performance improvement here depends on the size of your view
//    lbl.layer.shouldRasterize = YES;
    
    
    OhioBrandData *myData = nil;
    CGFloat step = 0;
    

    if (tableView == self.tableListView)
    {
        myData = [self.sorteddata objectAtIndex:indexPath.row];
        step = 1.0 / (self.sorteddata.count );
    }
    else
    {
        NSLog(@"inside search results view");
        myData = [self.searchResults objectAtIndex:indexPath.row];
        step = 1.0 / (self.searchResults.count );
    }
    
    
    UIColor *start = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-indexPath.row*step];
    UIColor *end = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-(indexPath.row+1)*(step*1.1)];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[AppDelegate createGradientImageFromColor:start toColor:end withSize:cell.bounds.size] ];

    
    //NSLog(@"inside cell %@",[myData brandname]);

    //cell.cellItemLabel.text = [myData brandname];
    cell.titleLabel.text = [myData brandname];
    
    cell.BRetailLabel.text = [self formatPrice:[myData b_retailprice_1]];
    cell.MRetailLabel.text = [self formatPrice:[myData m_retailprice_1]];
    
    cell.ERetailLabel.text = [self formatPrice:[myData e_retailprice_1]];
    
    cell.LRetailLabel.text = [self formatPrice:[myData l_retailprice_1]];
    
    cell.DRetailLabel.text =[self formatPrice:[myData d_retailprice_1]];
    
    
    
    cell.BWholeSaleLabel.text = [self formatPrice:[myData b_wholesaleprice_1]];
    cell.MWholeSaleLabel.text = [self formatPrice:[myData m_wholesaleprice_1]];
    
    cell.EWholeSaleLabel.text = [self formatPrice:[myData e_wholesaleprice_1]];
    
    cell.LWholeSaleLabel.text = [self formatPrice:[myData l_wholesaleprice_1]];
    
    cell.DWholeSaleLabel.text =[self formatPrice:[myData d_wholesaleprice_1]];
    

    
    
    
    
    return cell;
}

-(NSString *) formatPrice :(NSString *) price
{
    NSString *newPrice = price;
    if (price == nil)
        newPrice = @"";
    if ([price isEqualToString:@"N/A"])
        newPrice = @"";
    return newPrice;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (tableView == self.tableListView)
    {
        return [self.sorteddata count];
    }
    else
    {
        NSLog(@"%lu", (unsigned long)[self.searchResults count]);
        return [self.searchResults count];
    }

}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
////    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNav"];
////    nav.transitioningDelegate = self;
////    
////    DetailViewController *controller = nav.viewControllers[0];
////    controller.liqormodel = self.sorteddata[tableListView.indexPathForSelectedRow.row];
////    
////    [self presentViewController:nav animated:YES completion:nil];
//}


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


- (IBAction)actionClose:(id)sender {
   // [super viewDidDisappear:animated];
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadRecordsFromCoreData {
    
    NSLog(@"inside loadRecordsFromCoreData Agency code is %@", agencyCode);
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"brandname" ascending:YES]]];
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"agencynumber == %@",agencyCode];
        
        request.predicate = p;
        
        self.data = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"brandname" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        self.sorteddata = [self.data sortedArrayUsingDescriptors:sortDescriptors];
        self.searchResults = self.sorteddata;
        NSLog((@"loading in block thread complete"));
        
        NSLog(@"count is %d",[self.searchResults count]);
    }];
    
    NSLog(@" loading finish");
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20.0f;
//}

- (IBAction)refreshButtonClicked:(id)sender {
    NSLog(@"Inside refreshButtonClicked for BrandsViewController");
    [[SDSyncEngine sharedEngine] startSync];
    
   // self.brandsearchbar.frame = CGRectMake(0.0, 0, 320, 44);
}


- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        NSLog(@"sync in progress");
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
         NSLog(@"sync is complete");
      //  [self loadRecordsFromCoreData];
        //[self.tableListView reloadData];
       
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




@end

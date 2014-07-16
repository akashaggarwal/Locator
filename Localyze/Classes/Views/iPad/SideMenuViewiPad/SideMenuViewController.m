//
//  SideMenuViewController.m
//  RadioJive
//
//  Created by Valentin Filip on 9/10/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MasteriPadViewController.h"
#import "DetailiPadViewController.h"
#import "AppDelegate.h"

#import "ThemeListCell.h"

#import "DataLoader.h"

@interface SideMenuViewController () {
    UIColor *startColor;
    UIColor *endColor;
}

@property (nonatomic, strong) UIViewController *childVC;

@property (strong, nonatomic) NSArray       *models;

@end

@implementation SideMenuViewController

@synthesize tableView = _tableView;
@synthesize currentlySelectedIndex;
//@synthesize childVC;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
    startColor = [UIColor colorWithRed:0.70f green:0.73f blue:0.81f alpha:1.00f];
    endColor = [UIColor colorWithRed:0.46f green:0.49f blue:0.57f alpha:1.00f];
    
    UITabBarController *tabBarC = ((UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController);
    UINavigationController *nav = tabBarC.viewControllers[0];
    MasteriPadViewController *masterVC = nav.viewControllers[0];
    self.models = masterVC.data;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_tableView didSelectRowAtIndexPath:firstRow];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_tableView selectRowAtIndexPath:self.currentlySelectedIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_tableView didSelectRowAtIndexPath:self.currentlySelectedIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LocationCell";
    
    ThemeListCell *cell = (ThemeListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    cell.selectedBackgroundView = backView;
    
    CGFloat step = 1.0 / (_models.count > 10 ? _models.count : 10);
    UIColor *start = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-indexPath.row*step];
    UIColor *end = [AppDelegate colorBetweenColor:startColor andColor:endColor forDegreesFahrenheit:1-((indexPath.row+1)* (0.8*step))];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[AppDelegate createGradientImageFromColor:start toColor:end withSize:cell.bounds.size] ];
    
    cell.model = _models[indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITabBarController *tabBarC = ((UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController);
    UINavigationController *nav = tabBarC.viewControllers[0];
    MasteriPadViewController *masterVC = nav.viewControllers[0];
    [masterVC dismissSidebar:nil];
    
    DetailiPadViewController *detailVC = (DetailiPadViewController *)masterVC.detailViewController;
    detailVC.item = _models[indexPath.row];
}


@end

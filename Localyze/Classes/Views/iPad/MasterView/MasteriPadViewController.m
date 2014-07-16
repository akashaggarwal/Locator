//
//  MasteriPadViewController.m
//  RadioJive
//
//  Created by Valentin Filip on 9/10/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "MasteriPadViewController.h"
#import "ADVTheme.h"
#import "SideMenuViewController.h"
#import "DetailiPadViewController.h"

#import "DataLoader.h"

@interface MasteriPadViewController () {
    UIBarButtonItem *labelItem, *spaceItem, *toggleItem;
    UIButton        *btnArrow;
    UIView          *viewTitle;
}

@property (assign, nonatomic) BOOL isWide;

@end


CGFloat kMenuWidth = 0;
CGFloat kMenuWidthExpanded = 320;

@implementation MasteriPadViewController

@synthesize menuViewController, detailViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [DataLoader locations];
    
    CGFloat width = kMenuWidth;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        width = kMenuWidthExpanded;
        self.isWide = YES;
    } else {
        self.isWide = NO;
    }
	leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width,
                                                            CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
	leftMenuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    leftMenuView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMenu"]];
    menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    menuViewController.view.frame = CGRectMake(0, 0, leftMenuView.frame.size.width, leftMenuView.frame.size.height);
	[menuViewController.view setBackgroundColor:[UIColor clearColor]];
	[menuViewController viewWillAppear:FALSE];
	[menuViewController viewDidAppear:FALSE];
    
	[leftMenuView addSubview:menuViewController.view];
	
	rightSlideView = [[UIView alloc] initWithFrame:CGRectMake(leftMenuView.frame.size.width, 0, self.view.frame.size.width - leftMenuView.frame.size.width, self.view.frame.size.height)];
	rightSlideView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	   
    detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.view.frame = rightSlideView.bounds;
    detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
    [rightSlideView addSubview:detailViewController.view ];
	
	[self.view addSubview:rightSlideView];
	[self.view addSubview:leftMenuView];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroundImage_repeat.png"]]];
    
    id<ADVTheme> theme = [ADVThemeManager sharedTheme];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [theme navigationTextColor];
    labelTitle.font = [theme navigationFont];
    labelTitle.text = @"Locations";
    [labelTitle sizeToFit];
    viewTitle = [[UIView alloc] initWithFrame:labelTitle.bounds];
    CGRect frameLbl = labelTitle.bounds;
    frameLbl.origin.x = 10;
    labelTitle.frame = frameLbl;
    CGRect frameView = viewTitle.bounds;
    frameView.size.width += 10;
    viewTitle.frame = frameView;
    [viewTitle addSubview:labelTitle];
    labelItem = [[UIBarButtonItem alloc] initWithCustomView:viewTitle];
    
    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(0, 0, 20, 40);
    [btnArrow addTarget:self action:@selector(toggleSidebar:) forControlEvents:UIControlEventTouchUpInside];
    
    spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [self setTitleAndToggle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [menuViewController viewDidAppear:NO];
    [self.detailViewController viewDidAppear:NO];
    
    CGFloat width = kMenuWidth;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        width = kMenuWidthExpanded;
        self.isWide = YES;
    } else {
        self.isWide = NO;
    }
    leftMenuView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.view.bounds));
    menuViewController.view.frame = CGRectMake(0, 0, leftMenuView.frame.size.width, leftMenuView.frame.size.height);
    
//    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (self.detailViewController) {
        return [self.detailViewController supportedInterfaceOrientations];
    }
    return (UIInterfaceOrientationMaskAllButUpsideDown);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.detailViewController) {
        return [self.detailViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {    
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.detailViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    CGFloat originX = -kMenuWidthExpanded;
    if (!self.isWide) {
        originX = 0;
        self.isWide = YES;
    } else {
        self.isWide = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frameLeft = leftMenuView.frame;
        frameLeft.origin.x = originX;
        frameLeft.size.width = kMenuWidthExpanded;
        leftMenuView.frame = frameLeft;
        
        CGRect frameRight = rightSlideView.frame;
        frameRight.origin.x = CGRectGetMaxX(frameLeft);
        frameRight.size.width = CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(frameLeft);
        rightSlideView.frame = frameRight;
        
        [menuViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setTitleAndToggle];
    }];
    
	[menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [menuViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Visual stuff

- (void)setTitleAndToggle {
    NSString *imgArrowName = [NSString stringWithFormat:@"barButtonArrow%@", (self.isWide ? @"-left" : @"-right")];
    UIImage *imgArrow = [UIImage imageNamed:imgArrowName];
    [btnArrow setImage:imgArrow forState:UIControlStateNormal];
    toggleItem = [[UIBarButtonItem alloc] initWithCustomView:btnArrow];
    
    spaceItem.width = self.isWide ? kMenuWidthExpanded - viewTitle.bounds.size.width : 10;
    
    self.navigationItem.leftBarButtonItems = self.isWide ? @[labelItem, spaceItem, toggleItem] : @[spaceItem, toggleItem, labelItem];
}



#pragma mark - Actions

- (void)dismissSidebar:(id)sender {
    if (self.isWide && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self toggleSidebar:nil];
    }
}

- (IBAction)toggleSidebar:(id)sender {
    CGFloat originX = -kMenuWidthExpanded;
    if (!self.isWide) {
        originX = 0;
        self.isWide = YES;
    } else {
        self.isWide = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frameLeft = leftMenuView.frame;
        frameLeft.origin.x = originX;
        frameLeft.size.width = kMenuWidthExpanded;
        leftMenuView.frame = frameLeft;
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            CGRect frameRight = rightSlideView.frame;
            frameRight.origin.x = CGRectGetMaxX(frameLeft);
            frameRight.size.width = CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(frameLeft);
            rightSlideView.frame = frameRight;
        }
        
        [menuViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setTitleAndToggle];
    }];
    
}



@end

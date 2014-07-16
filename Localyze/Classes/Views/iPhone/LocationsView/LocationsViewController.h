//
//  LocationsViewController.h
//  Localyse
//
//  Created by Valentin Filip on 18/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>

@property (nonatomic, retain) NSArray* models;

@property (nonatomic, strong) IBOutlet UITableView* tableListView;

@property (nonatomic, strong) IBOutlet UILabel* nearestLabel;
@property (nonatomic, strong) IBOutlet UILabel* furthestLabel;

@property (strong, nonatomic) IBOutlet UIButton *buttonAddLocation;


@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *sorteddata;
@property (nonatomic, strong) NSString *entityName;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonClicked:(id)sender;

@end

//
//  ThemeListCell.h
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Model;
@class AgencyData;

@interface ThemeListCell : UITableViewCell

@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) AgencyData *liqormodel;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* locationLabel;
@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* distanceMetricLabel;
@property (nonatomic, strong) IBOutlet UILabel* paidTypeLabel;

@end

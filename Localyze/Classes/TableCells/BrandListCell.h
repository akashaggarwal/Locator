//
//  ThemeListCell.h
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class Model;
//@class OhioBrandData;

@interface BrandListCell : UITableViewCell

//@property (nonatomic, strong) Model *model;
//@property (nonatomic, strong) OhioBrandData *brandmodel;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* retailPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel* WholeSalePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel* ERetailLabel;
@property (nonatomic, strong) IBOutlet UILabel* MRetailLabel;
@property (nonatomic, strong) IBOutlet UILabel* BRetailLabel;
@property (nonatomic, strong) IBOutlet UILabel* LRetailLabel;
@property (nonatomic, strong) IBOutlet UILabel* DRetailLabel;

@property (nonatomic, strong) IBOutlet UILabel* EWholeSaleLabel;
@property (nonatomic, strong) IBOutlet UILabel* MWholeSaleLabel;
@property (nonatomic, strong) IBOutlet UILabel* BWholeSaleLabel;
@property (nonatomic, strong) IBOutlet UILabel* LWholeSaleLabel;
@property (nonatomic, strong) IBOutlet UILabel* DWholeSaleLabel;


//@property (nonatomic, strong) IBOutlet UILabel* locationLabel;
//@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;
//@property (nonatomic, strong) IBOutlet UILabel* distanceMetricLabel;
//@property (nonatomic, strong) IBOutlet UILabel* paidTypeLabel;

@end

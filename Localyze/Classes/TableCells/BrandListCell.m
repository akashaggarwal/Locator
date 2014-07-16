//
//  ThemeListCell.m
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "BrandListCell.h"
#import "Model.h"
#import "AppDelegate.h"
#import "OhioBrandData.h"

#import <QuartzCore/QuartzCore.h>

@implementation BrandListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(24, 11, 295, 21)];
//        self.titleLabel.textColor = [UIColor darkGrayColor];
//        self.titleLabel.font = [UIFont fontWithName:@"System" size:17];
//        
//        
//        self.retailPriceLabel= [[UILabel alloc] initWithFrame:CGRectMake(24, 36, 33, 21)];
//        self.retailPriceLabel.textColor = [UIColor whiteColor];
//        self.retailPriceLabel.font = [UIFont fontWithName:@"System" size:7];
//        self.retailPriceLabel.text = @"Retail:";
//        
//        self.WholeSalePriceLabel= [[UILabel alloc] initWithFrame:CGRectMake(24, 65, 42, 21)];
//        self.WholeSalePriceLabel.textColor = [UIColor whiteColor];
//        self.WholeSalePriceLabel.font = [UIFont fontWithName:@"System" size:7];
//         self.WholeSalePriceLabel.text = @"Wholesale:";
//        
//        
//        [self addSubview:self.titleLabel];
//        [self addSubview:self.retailPriceLabel];
//        [self addSubview:self.WholeSalePriceLabel];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
- (void)layoutSubviews {
    [super layoutSubviews];
}
//
//    _titleLabel.text = _brandmodel.brandname;
//    
//    // cell.detailTextLabel.text  = [NSString stringWithFormat:@"%@\n%@ %@\n%@\n%@\n%@\n",myData.address, myData.city, myData.zip , myData.phone, myData.location, myData.distanceFromCurrent];
//    
//    
//    //_titleLabel.textColor = [UIColor whiteColor];
//    //_titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
//    
//    _BRetailLabel.text = _brandmodel.b_retailprice_1;
//    _MRetailLabel.text = _brandmodel.m_retailprice_1;
//
//    _ERetailLabel.text = _brandmodel.e_retailprice_1;
//
//    _LRetailLabel.text = _brandmodel.l_retailprice_1;
//
//    _DRetailLabel.text =_brandmodel.d_retailprice_1;
//
//    
//    
//    _BWholeSaleLabel.text = _brandmodel.b_wholesaleprice_1;
//    _MWholeSaleLabel.text = _brandmodel.m_wholesaleprice_1;
//    
//    _EWholeSaleLabel.text = _brandmodel.e_wholesaleprice_1;
//    
//    _LWholeSaleLabel.text = _brandmodel.l_wholesaleprice_1;
//    
//    _DWholeSaleLabel.text =_brandmodel.d_wholesaleprice_1;
//
//    
////    NSString *address = [NSString stringWithFormat:@"%@\n%@ OH %@",_liqormodel.address, _liqormodel.city, _liqormodel.zip ];
////    _locationLabel.text = address;
////    _locationLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
////    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
////    
////    _distanceMetricLabel.text = [@"mi" lowercaseString];
////    _distanceMetricLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
////    _distanceMetricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
////    
////    
////    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_liqormodel.distanceFromCurrent.doubleValue];
////    _distanceLabel.textColor = [UIColor whiteColor];
////    _distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
//}
//
@end

//
//  ThemeListCell.m
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "ThemeListCell.h"
#import "Model.h"
#import "AppDelegate.h"
#import "AgencyData.h"

#import <QuartzCore/QuartzCore.h>

@implementation ThemeListCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //_titleLabel.text = _model.title;
    //_titleLabel.text = _liqormodel.agencyname;
    NSString *dbaname = _liqormodel.dba;
    if ([dbaname hasPrefix:@"DBA"] || [dbaname hasPrefix:@"dba"])
        dbaname = [dbaname substringFromIndex:3];
    _titleLabel.text = dbaname;
    
   // cell.detailTextLabel.text  = [NSString stringWithFormat:@"%@\n%@ %@\n%@\n%@\n%@\n",myData.address, myData.city, myData.zip , myData.phone, myData.location, myData.distanceFromCurrent];
    
    
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    NSString *address = [NSString stringWithFormat:@"%@\n%@ OH %@",_liqormodel.address, _liqormodel.city, _liqormodel.zip ];
    _locationLabel.text = address;
    _locationLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    
    _distanceMetricLabel.text = [@"mi" lowercaseString];
    _distanceMetricLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _distanceMetricLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
 
    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f",_liqormodel.distanceFromCurrent.doubleValue];
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
}

@end

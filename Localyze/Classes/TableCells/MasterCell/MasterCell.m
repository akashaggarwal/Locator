//
//  MasterCell.m
//  Localyze
//
//  Created by Valentin Filip on 27/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "MasterCell.h"

@implementation MasterCell

@synthesize titleLabel, distanceLabel, locationLabel, paidTypeLabel, distanceMetricLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

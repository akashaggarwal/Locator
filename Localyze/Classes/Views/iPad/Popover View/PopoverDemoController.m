//
//  PopoverDemoController.m
//
//
//  Created by Valentin Filip on 18/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "PopoverDemoController.h"




@implementation PopoverDemoController



#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(270, 160);
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
    _btnFirst.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:21];
    [_btnFirst setTitleColor:[UIColor colorWithRed:0.56f green:0.58f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
    
    _btnSecond.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:21];
    [_btnSecond setTitleColor:[UIColor colorWithRed:0.47f green:0.49f blue:0.56f alpha:1.00f] forState:UIControlStateNormal];
}

@end

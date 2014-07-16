//
//  OtherViewController.m
//  
//
//  Created by Valentin Filip on 7/29/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "OtherViewController.h"

#import "ADVTheme.h"

@interface OtherViewController ()

@end




@implementation OtherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [ADVThemeManager customizeView:self.view];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.text = @"OTHER";
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont fontWithName:@"Avenir-Black" size:19];
    [labelTitle sizeToFit];
    self.navigationItem.titleView = labelTitle;
}

@end

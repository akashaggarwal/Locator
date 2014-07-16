//
//  SearchViewController.h
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZipViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *alternativeLabel;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)actionSearch:(id)sender;
- (IBAction)actionClose:(id)sender;

@end

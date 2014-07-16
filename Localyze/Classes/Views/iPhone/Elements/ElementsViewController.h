//
//  ElementsViewController.h
//  
//
//  Created by Valentin Filip on 17/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
@class RCSwitch, NYSliderPopover, NMRangeSlider, ADVProgressBar;


@interface ElementsViewController : UIViewController <UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
//
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (strong, nonatomic) IBOutlet NYSliderPopover *sliderView;
//@property (strong, nonatomic) IBOutlet ADVProgressBar *progressView;
//@property (strong, nonatomic) IBOutlet NMRangeSlider *rangeSliderView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UIButton *buttonFirst;
//@property (strong, nonatomic) IBOutlet UIButton *buttonSecond;
//@property (strong, nonatomic) IBOutlet RCSwitch *onSwitch;
//@property (strong, nonatomic) IBOutlet RCSwitch *offSwitch;
//@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
//
//
//- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)actionClose:(id)sender;
- (IBAction)contactUs:(id)sender;
@end

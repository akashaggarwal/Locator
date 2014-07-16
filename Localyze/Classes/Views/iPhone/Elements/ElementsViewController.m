//
//  ElementsViewController.m
//  
//
//  Created by Valentin Filip on 17/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "ElementsViewController.h"
#import "ADVTheme.h"
#import "RCSwitch.h"
#import "ADVProgressBar.h"
#import "AppDelegate.h"
#import "NYSliderPopover.h"
#import "NMRangeSlider.h"
#import "ADVProgressBar.h"


@interface ElementsViewController ()

@property (nonatomic, strong) UIView                *lowerValueView;
@property (nonatomic, strong) UIView                *upperValueView;

@end



@implementation ElementsViewController

@synthesize scrollView;
@synthesize segment;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScroll:)];
//    gesture.delegate = self;
//    [self.scrollView addGestureRecognizer:gesture];
    
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
//    labelTitle.text = @"ELEMENTS";
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor whiteColor];
//    labelTitle.font = [UIFont fontWithName:@"Avenir-Black" size:17];
//    [labelTitle sizeToFit];
//    self.navigationItem.titleView = labelTitle;
    
    id<ADVTheme> theme = [ADVThemeManager sharedTheme];
//    _rangeSliderView.backgroundColor = [UIColor clearColor];
//    _rangeSliderView.trackBackgroundImage = [theme sliderMaxTrackDouble];
//    
//    _rangeSliderView.trackImage = [theme sliderMinTrackDouble];
//    
//    _rangeSliderView.lowerHandleImageNormal = [theme sliderThumbForState:UIControlStateNormal];
//    _rangeSliderView.upperHandleImageNormal = [theme sliderThumbForState:UIControlStateNormal];
//    
//    _rangeSliderView.lowerHandleImageHighlighted = [theme sliderThumbForState:UIControlStateNormal];
//    _rangeSliderView.upperHandleImageHighlighted = [theme sliderThumbForState:UIControlStateNormal];
//    
//    _rangeSliderView.minimumValue = 0;
//    _rangeSliderView.maximumValue = 100;
//    _rangeSliderView.upperValue = 79;
//    _rangeSliderView.lowerValue = 22;
//    
//    self.lowerValueView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    
//    _progressView.progress = _sliderView.value / 100;
//    
//    CGFloat switchHeight = 32;
//    
//    self.onSwitch = [[RCSwitch alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_progressView.frame)  + 25, 61, switchHeight)];
//    [_onSwitch setOn:YES];
//    [self.scrollView addSubview:_onSwitch];
//    
//    self.offSwitch = [[RCSwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onSwitch.frame) + 20, CGRectGetMinY(_onSwitch.frame), 61, switchHeight)];
//    [_offSwitch setOn:NO];
//    [self.scrollView addSubview:_offSwitch];
    
    self.buttonFirst.titleLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:15];
//    self.buttonSecond.titleLabel.font =  [UIFont fontWithName:@"Avenir-Heavy" size:15];
//    
    CGRect frameSegm = self.segment.frame;
    frameSegm.size.height = 30;
    self.segment.frame = frameSegm;
    self.segment.tintColor = [theme segmentedTintColor];
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, CGRectGetMaxY(_offSwitch.frame) + 25);
//    
    //[self customizeTabs];
}


//- (void)customizeTabs {
//    NSArray *items = self.tabBar.items;
//    for (int idx = 0; idx < items.count; idx++) {
//        UITabBarItem *item = items[idx];
//        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
//    }
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions
//
//- (IBAction)sliderValueChanged:(id)sender {    
//    if([sender isKindOfClass:[UISlider class]]) {
//        UISlider *s = (UISlider*)sender;
//        CGFloat value = s.value / 100;
//        if(value >= 0.0 && value <= 1.0) {
//            if (self.progressView) {
//                self.progressView.progress = value;
//            }
//        }
//    }
//}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    //[self setScrollView:nil];
    [self setButtonFirst:nil];
    //[self setButtonSecond:nil];
    [super viewDidUnload];
}

#pragma mark - Utils

- (BOOL)isTall {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
        && [UIScreen mainScreen].bounds.size.height == 568)
    {
        return YES;
    }
    return NO;
}


#pragma mark - UITapGestureRecognizer delegate

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    return !([touch.view isEqual:_onSwitch] || [touch.view isEqual:_offSwitch]);
//}
//
//- (void)didTapScroll:(UIGestureRecognizer *)recognizer {
//    
//    [self.scrollView endEditing:YES];
//}
- (IBAction)contactUs:(id)sender
{
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";

    switch(self.segment.selectedSegmentIndex)
    {
        case 0: emailTitle = @"Sales Inquiry";
                messageBody = @"if you are interested in building a similar locator app for your business, please put your information below with the name/ number / email to contact you";
            break;
        case 1: emailTitle = @"Support Inquiry";
            messageBody = @"if you are believe there is an issue with the app, please help us improve by providing detailed steps to simulate the issue. If the information provided is incorrect, please indicate the store information or brand information for which the information you believe is incorrect.";
            
            break;
        case 2: emailTitle = @"Feedback";
            messageBody = @"We value your comments / feedback and strive to improve so as to provide the best experience. Your feedback is valuable and we will do our best to add more value to this app.";
            
            break;
            
    }
       // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"cincywebmobilesolutionsllc@yahoo.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end

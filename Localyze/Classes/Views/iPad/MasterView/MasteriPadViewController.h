//
//  MasteriPadViewController.h
//  RadioJive
//
//  Created by Valentin Filip on 9/10/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SideMenuViewController;
@class TasksiPadViewController;


@interface MasteriPadViewController : UIViewController {
	UIView* leftMenuView;
	UIView* rightSlideView;
	
	SideMenuViewController* menuViewController;
	UIViewController* currentViewController;
    
}

@property (nonatomic, strong) SideMenuViewController *menuViewController;
@property (nonatomic, strong, readonly) NSArray *data;
@property (nonatomic, strong) UIViewController  *detailViewController;

- (void)dismissSidebar:(id)sender;
- (IBAction)toggleSidebar:(id)sender;

@end

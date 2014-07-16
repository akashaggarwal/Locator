//
//  BrandsViewController.h
//  LiqorStoreLocator
//
//  Created by Akash Aggarwal on 7/4/14.
//
//

#import <UIKit/UIKit.h>

@interface BrandsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>


@property (nonatomic, strong) IBOutlet UITableView* tableListView;




@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *sorteddata;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *agencyCode;
@property (nonatomic, strong) NSString *agencyName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)actionClose:(id)sender ;



@end


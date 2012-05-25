//
//  BookViewController.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-14.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContinuousTableView.h"
#import "MBProgressHUD.h"


#define MAX_RESULTS 10

@interface BookViewController : UIViewController{
    NSString *searchedString;
	NSInteger totalResults;
	NSInteger startIndex;
    MBProgressHUD *HUD;
    
    
}

@property (nonatomic, strong) NSMutableArray *tableData;

//@property (nonatomic, weak) IBOutlet UITableView *theTableView;
@property (nonatomic, weak) IBOutlet UISearchBar *theSearchBar;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@property(nonatomic, weak) IBOutlet ContinuousTableView *theTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property(nonatomic,copy)	NSString *searchedString;

- (void)loadMore;

@end

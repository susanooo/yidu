//
//  BookReviewsViewController.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-20.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContinuousTableView.h"
#import "MBProgressHUD.h"

@interface BookReviewsViewController : UIViewController {
	ContinuousTableView *reviewTableView;
    
	MBProgressHUD *HUD;
    
	NSMutableArray *reviews;
	NSString *isbn;
	NSInteger totalResults;
	NSInteger startIndex;
	
	NSString *connectionUUID;
}
@property(nonatomic,retain) IBOutlet ContinuousTableView *reviewTableView; 
@property(nonatomic,copy) NSString *isbn;

- (void)didGetBookReviews:(NSDictionary *)userInfo;
- (void)loadMore;
@end

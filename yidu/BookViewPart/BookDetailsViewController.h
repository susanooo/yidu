//
//  BookDetailsViewController.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-19.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BookDetails.h"

@interface BookDetailsViewController : UIViewController{
	
	MBProgressHUD *HUD;
	NSString *connectionUUID;
	
	NSArray *bookItemNames;
	NSArray *bookItemImageNames;
	
}
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;
@property (nonatomic, copy) NSString *isbn;
@property (nonatomic, strong) BookDetails *book;

- (void)didGetDoubanBook:(NSDictionary *)userInfo;

@end

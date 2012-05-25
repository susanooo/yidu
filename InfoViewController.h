//
//  InfoViewController.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    NSMutableArray *dataArray;
    UITableView *moreTableView;
}
@property(nonatomic, retain)IBOutlet UITableView *moreTableView;

- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;

@end

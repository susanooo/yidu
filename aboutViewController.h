//
//  aboutViewController.h
//  yidu
//
//  Created by 智超 常 on 12-5-7.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aboutViewController : UIViewController{
    UITableView *aboutTableView;
    NSArray *dataArray;
}
@property(nonatomic, retain) IBOutlet UITableView *aboutTableView;

@end

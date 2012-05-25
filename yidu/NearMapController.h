//
//  NearMapController.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NearMapController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UISegmentedControl *select;
    MapViewController *mapViewController;
    UITableView *resultTable;
    NSMutableArray *poiResult;
    NSDictionary *poiResultDic;
    NSMutableArray *testArray;
    UIView *_hudView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@property(strong,nonatomic)UISegmentedControl *select;
@property(strong,nonatomic)MapViewController *mapViewController;
@property(nonatomic, retain)IBOutlet UITableView *resultTable;
@property(nonatomic,strong)NSMutableArray *poiResult;
@property(strong,nonatomic)NSDictionary *poiResultDic;
@property(strong,nonatomic)NSMutableArray *testArray;
@property(strong,nonatomic)UIView *_hudView;
@property(strong,nonatomic)UIActivityIndicatorView *_activityIndicatorView;



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;




-(void)mapShow;
-(void)changeKey;
-(void)tableShow;
-(void)killActivity:(UIActivityIndicatorView *)activity;
-(void)getPoiValue;

@end
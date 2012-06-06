//
//  MapViewController.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapSearchControllerViewController.h"
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate>{
    mapSearchControllerViewController *searchViewController;
    UISegmentedControl *select;
    BMKMapView* _mapView;
    BMKSearch *_search;
    NSString *key;
    NSMutableArray *poiResult;
    NSString *temp;
}
@property(strong,nonatomic)BMKMapView* _mapView;
@property(strong,nonatomic)BMKSearch *_search;
@property(strong,nonatomic)NSString *key;
@property(strong,nonatomic)UISegmentedControl *select;
@property(strong,nonatomic)NSString *temp;
@property(strong,nonatomic)NSMutableArray *poiResult;
@property(strong,nonatomic)mapSearchControllerViewController *searchViewController;


-(void)poiResultCheck:(NSString *)key;
-(BOOL)changeKeyCheck;
-(void)mapShow;
-(void)changeKey;
@end

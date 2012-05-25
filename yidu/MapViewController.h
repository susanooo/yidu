//
//  MapViewController.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate>{
    
    BMKMapView* _mapView;
    BMKSearch *_search;
    NSString *key;
    NSMutableArray *cafeResult;
    NSString *temp;
    NSMutableArray *libResult;
    NSMutableArray *bSResult;
    int a;
}
@property(strong,nonatomic)BMKMapView* _mapView;
@property(strong,nonatomic)BMKSearch *_search;
@property(strong,nonatomic)NSString *key;
@property(strong,nonatomic)NSMutableArray *cafeResult;
@property(strong,nonatomic)NSString *temp;
@property(strong,nonatomic)NSMutableArray *libResult;
@property(strong,nonatomic)NSMutableArray *bSResult;

-(void)poiResultCheck:(NSString *)key;
-(BOOL)changeKeyCheck;
-(void)getLibResult;
-(void)getCafeResult;
@end
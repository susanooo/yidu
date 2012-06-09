//
//  AppDelegate.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewController.h"
#import "PartyViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"
#import "BMapKit.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBar;
    UINavigationController *navigationController;
    UINavigationController *navigationController_info;
    UINavigationController *eventsNavigationController;
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBar;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UINavigationController *navigationController_info;
@property (strong, nonatomic) UINavigationController *bookDetailNavigationController;
@property (strong, nonatomic) UINavigationController *eventsNavigationController;


@end

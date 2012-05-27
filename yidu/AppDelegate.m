//
//  AppDelegate.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBar = _tabBar;
@synthesize navigationController;
@synthesize navigationController_info;
@synthesize bookDetailNavigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBar = [[UITabBarController alloc]initWithNibName:nil bundle:nil];

    MapViewController *map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    BookViewController *book = [[BookViewController alloc]initWithNibName:@"BookViewController" bundle:nil];
    PartyViewController *party = [[PartyViewController alloc]initWithNibName:@"PartyViewController" bundle:nil];
    InfoViewController *info = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc]init];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController pushViewController:map animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController_info = [[UINavigationController alloc]init];
    self.navigationController_info.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController_info pushViewController:info animated:NO];
    [self.navigationController_info setNavigationBarHidden:NO];
    
    self.bookDetailNavigationController = [[UINavigationController alloc]init];
    self.bookDetailNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.bookDetailNavigationController pushViewController:book animated:NO];

    self.tabBar.viewControllers = [NSArray arrayWithObjects:self.navigationController,self.bookDetailNavigationController,party,self.navigationController_info,nil];
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"C15E8264E7AF56A0693A54D3723A484F3F502642" generalDelegate:nil];

    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window.rootViewController = self.tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

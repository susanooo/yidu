//
//  mapSearchControllerViewController.h
//  yidu
//
//  Created by Chiong Amber on 12-5-26.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mapSearchControllerViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>{
    UISearchDisplayController *displayController;
    UISearchBar *searchBar;
    
    NSArray *allItems;
    NSArray *searchResults;
}


@property(strong,nonatomic)NSArray *allItems;
@property(strong,nonatomic)NSArray *searchResults;

@property(strong,nonatomic)UISearchDisplayController *displayController;
@property(strong,nonatomic)UISearchBar *searchBar;

@end

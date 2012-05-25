//
//  LoadingTableViewCell.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-15.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingTableViewCell : UITableViewCell {
	UIActivityIndicatorView *indicator;
	UILabel *loadingLabel;
}
@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property(nonatomic,retain) UILabel *loadingLabel;
@end 

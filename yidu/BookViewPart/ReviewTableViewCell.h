//
//  ReviewTableViewCell.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-20.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookReviewSummary.h"

@interface ReviewTableViewCell : UITableViewCell {
	
	UIImageView *authorAvatarImageView;
	UILabel *titleLabel;
	UILabel *authorNameLabel;
	UILabel *reviewLabel;
	UILabel *dateLabel;
}
@property(nonatomic,weak) BookReviewSummary *review;

@end

//
//  BookDetailCell.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-16.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetails.h"
#import "RatingDisplayView.h"

@interface BookDetailCell : UITableViewCell {
	UIImageView *coverView;
	UILabel *bookAuthorLabel;
	UILabel *bookPublisherLabel;
	UILabel *bookPubDateLabel;
	UILabel *priceLabel;
	UILabel *ISBNLabel;
	RatingDisplayView *ratingView;
    
	UILabel *ratingTailLabel;
}
@property(nonatomic,assign) BookDetails *book;

@end

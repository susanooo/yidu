//
//  BookTableViewCell.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-14.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookDetails.h"
@interface BookTableViewCell : UITableViewCell {
	BookDetails *book;
	
	UIImageView *bookCoverImageView;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UILabel *publisherLabel;
	UILabel *pubDateLabel;
}
@property(nonatomic,strong) BookDetails *book;
@end

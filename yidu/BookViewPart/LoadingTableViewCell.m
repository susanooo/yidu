//
//  LoadingTableViewCell.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-15.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//


#import "LoadingTableViewCell.h"

@interface LoadingTableViewCell()
- (void)addIndicator;
- (void)addLoadingLabel;
@end

@implementation LoadingTableViewCell
@synthesize indicator;
@synthesize loadingLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		[self addIndicator];
		[self addLoadingLabel];
	}
	return self;
}

- (void)addIndicator{
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	indicator.hidesWhenStopped = YES;
	[indicator startAnimating];
	[self.contentView addSubview:indicator];
}

- (void)addLoadingLabel{
	loadingLabel = [[UILabel alloc] init];
	loadingLabel.text = @"正在加载...";
	loadingLabel.font = [UIFont systemFontOfSize:16];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	[self.contentView addSubview:loadingLabel];
	
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    CGSize  lableSize = [loadingLabel.text sizeWithFont:loadingLabel.font];
    loadingLabel.frame = CGRectMake(0, 0, lableSize.width, lableSize.height);
    int width = indicator.frame.size.width + loadingLabel.frame.size.width + 10;
    int left = (size.width - width) / 2.0;
    int middle = floor(size.height/2.0);
    self.indicator.center = CGPointMake(floor(left + indicator.frame.size.width/2.0), middle);
    self.loadingLabel.center = CGPointMake(floor(left+width-loadingLabel.frame.size.width/2.0), middle);
}

@end


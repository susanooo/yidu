//
//  RatingDisplayView.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-16.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "RatingDisplayView.h"

@implementation RatingDisplayView

@synthesize rating;

- (id)init{
	CGRect rect = CGRectMake(0, 0, 84, 16);
	if (self = [super initWithFrame:rect]) {
		oneStar = [UIImage imageNamed:@"onestar.png"];
		halfStar = [UIImage imageNamed:@"halfstar.png"];
		zeroStar = [UIImage imageNamed:@"zerostar.png"];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setRating:(CGFloat)_rating{
	rating = round(_rating);
	NSInteger index;
	CGFloat x = rating/2.0;
	for (index = 0; index < floor(x); index++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:oneStar];
		imageView.frame = [self rectForStarAtIndex:index];
		[self addSubview:imageView];
	}
	if (floor(x)!=x) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:halfStar];
		imageView.frame = [self rectForStarAtIndex:floor(x)];
		[self addSubview:imageView];
	}
	for (index = ceil(x); index<5; index++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:zeroStar];
		imageView.frame = [self rectForStarAtIndex:index];
		[self addSubview:imageView];
	}
}

- (CGRect)rectForStarAtIndex:(NSInteger)index{
	NSInteger x = index*16 + 1*(index - 1);
	return CGRectMake(x, 0, 16, 16);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

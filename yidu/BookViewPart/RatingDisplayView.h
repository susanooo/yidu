//
//  RatingDisplayView.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-16.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RatingDisplayView : UIView {
	UIImage *oneStar;
	UIImage *halfStar;
	UIImage *zeroStar;
	
	NSInteger maxRating;
	NSInteger minRating;
	CGFloat rating;
}
@property(nonatomic,assign) CGFloat rating;

- (CGRect)rectForStarAtIndex:(NSInteger)index;
@end

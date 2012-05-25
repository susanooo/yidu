//
//  ContinuousTableView.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-15.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "ContinuousTableView.h"
#import "EndStreamTableViewCell.h"
#import "LoadingTableViewCell.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)


@implementation ContinuousTableView
@synthesize isLoading;
@synthesize isLoadFailed;
@synthesize end;

- (void)setIsLoadFailed:(BOOL)isFailed{
	isLoadFailed = isFailed;
	[self reloadData];
}


- (UITableViewCell *)dequeueReusableEndCell{
	static NSString *CellIdentifier = @"LoadingCell";
	static NSString *EndCellIdentifier = @"EndCell";
    
    UITableViewCell *cell ;
	
	if (end) {
		cell = (EndStreamTableViewCell *)[self dequeueReusableCellWithIdentifier:EndCellIdentifier];
		if (!cell) {
			cell = [[EndStreamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EndCellIdentifier];
		}
	}else {
		cell = (LoadingTableViewCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		[((LoadingTableViewCell *)cell).indicator startAnimating];
		if (isLoadFailed) {
			((LoadingTableViewCell *)cell).loadingLabel.text = @"加载失败";    
			
		} else {
			((LoadingTableViewCell *)cell).loadingLabel.text = @"正在加载...";        
		}
	}
	
    return cell;
}



#pragma mark shadow
- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
	CGRect newShadowFrame =
	CGRectMake(0, 0, self.frame.size.width,
			   inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
	newShadow.frame = newShadowFrame;
	CGColorRef darkColor =
	[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:
	 inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5 : 0.5].CGColor;
	CGColorRef lightColor =
	[self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
	newShadow.colors =
	[NSArray arrayWithObjects:
	 (__bridge id)(inverse ? lightColor : darkColor),
	 (__bridge id)(inverse ? darkColor : lightColor),
	 nil];
	return newShadow;
}

//
// layoutSubviews
//
// Override to layout the shadows when cells are laid out.
//
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//
	// Construct the origin shadow if needed
	//
	if (!originShadow)
	{
		originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:originShadow atIndex:0];
	}
	else if (![[self.layer.sublayers objectAtIndex:0] isEqual:originShadow])
	{
		[self.layer insertSublayer:originShadow atIndex:0];
	}
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	//
	// Stretch and place the origin shadow
	//
	CGRect originShadowFrame = originShadow.frame;
	originShadowFrame.size.width = self.frame.size.width;
	originShadowFrame.origin.y = self.contentOffset.y;
	originShadow.frame = originShadowFrame;
	
	[CATransaction commit];
	
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if ([indexPathsForVisibleRows count] == 0)
	{
		[topShadow removeFromSuperlayer];
		topShadow = nil;
		[bottomShadow removeFromSuperlayer];
		bottomShadow = nil;
		return;
	}
	
	NSIndexPath *firstRow = [indexPathsForVisibleRows objectAtIndex:0];
	if ([firstRow section] == 0 && [firstRow row] == 0)
	{
		UIView *cell = [self cellForRowAtIndexPath:firstRow];
		if (!topShadow)
		{
			topShadow = [self shadowAsInverse:YES];
			[cell.layer insertSublayer:topShadow atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:topShadow] != 0)
		{
			[cell.layer insertSublayer:topShadow atIndex:0];
		}
		
		CGRect shadowFrame = topShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = -SHADOW_INVERSE_HEIGHT;
		topShadow.frame = shadowFrame;
	}
	else
	{
		[topShadow removeFromSuperlayer];
		topShadow = nil;
	}
	
	NSIndexPath *lastRow = [indexPathsForVisibleRows lastObject];
	if ([lastRow section] == [self numberOfSections] - 1 &&
		[lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1)
	{
		UIView *cell =
		[self cellForRowAtIndexPath:lastRow];
		if (!bottomShadow)
		{
			bottomShadow = [self shadowAsInverse:NO];
			[cell.layer insertSublayer:bottomShadow atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:bottomShadow] != 0)
		{
			[cell.layer insertSublayer:bottomShadow atIndex:0];
		}
		
		CGRect shadowFrame = bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = cell.frame.size.height;
		bottomShadow.frame = shadowFrame;
	}
	else
	{
		[bottomShadow removeFromSuperlayer];
		bottomShadow = nil;
	}
}

@end

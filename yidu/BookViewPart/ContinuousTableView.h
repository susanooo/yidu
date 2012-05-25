//
//  ContinuousTableView.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-15.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ContinuousTableView : UITableView {
	
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
	
	BOOL isLoading;//是否正在加载
	BOOL isLoadFailed;//是否加载失败
	BOOL end;
    
}
@property(nonatomic,assign) BOOL isLoading;
@property(nonatomic,assign) BOOL isLoadFailed;
@property(nonatomic,assign) BOOL end;

- (UITableViewCell *)dequeueReusableEndCell;
@end

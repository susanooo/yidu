//
//  DoubanURLConnection.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

typedef enum  {
	DOUBAN_BOOK = 0,
	DOUBAN_BOOKS,
	DOUBAN_PRICE,
	DOUBAN_BOOK_REVIEWS
} DoubanConnectionType;



@interface DoubanURLConnection : NSURLConnection {
	SEL responseAction;
}

@property(nonatomic,readonly)NSString *uuid;
@property(nonatomic,assign)id responseTarget;
@property(nonatomic,assign)SEL responseAction;
@property (nonatomic, assign) DoubanConnectionType type;

@end
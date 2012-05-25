//
//  DoubanURLConnection.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "DoubanURLConnection.h"
#import "NSString+UUID.h"

@implementation DoubanURLConnection
@synthesize uuid;
@synthesize type;
@synthesize responseTarget;
@synthesize responseAction;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate{
	if (self = [super initWithRequest:request delegate:delegate]) {
		uuid = [NSString newUUIDString];
	}
	return self;
}

@end
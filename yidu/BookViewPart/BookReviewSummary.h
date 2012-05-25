//
//  BookReviewSummary.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface BookReviewSummary : NSObject

@property(nonatomic,copy) NSString *updatedTime;
@property(nonatomic,copy) NSString *authorName;
@property(nonatomic,copy) NSString *authorIcon;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *summary;

+ (BookReviewSummary *)bookReviewFromXMLElement:(GDataXMLElement *)rootElement;

@end

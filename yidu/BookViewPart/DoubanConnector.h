//
//  DoubanConnector.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "DoubanURLConnection.h"

//搜索链接http://api.douban.com/movie/subjects?q=全文检索的关键词,tag=搜索特定tag,start-index	=起始元素	,max-results=返回结果的数量

#define DOUBAN_BOOK_QUERY_API @"http://api.douban.com/book/subjects"

#define DOUBAN_BOOK_ISBN_API @"http://api.douban.com/book/subject/isbn"

#define DOUBAN_API_KEY @"0134576358645063039d062a092cf129"

@class BookDetails;

@interface DoubanConnector : NSObject{
	NSMutableDictionary *connectionPool;
	NSMutableData *responseData;
}


//获取单例
+ (DoubanConnector *)sharedDoubanConnector;

- (void)removeConnectionWithUUID:(NSString *)uuid;

- (NSString *)requestBookDataWithISBN:(NSString *)isbn
                       responseTarget:(id)target
                       responseAction:(SEL)action;

- (NSString *)requestQueryBooksWithQueryString:(NSString *)queryString
                                responseTarget:(id)target
                                responseAction:(SEL)action;

- (NSString *)requestBookReviewsWithISBN:(NSString *)isbn 
                             queryString:(NSString *)string 
                          responseTarget:(id)target 
                          responseAction:(SEL)action;


- (NSString *)sendRequestWithURLString:(NSString *)urlString 
                                  type:(DoubanConnectionType)connectionType
                        responseTarget:(id)target
                        responseAction:(SEL)action;


@end

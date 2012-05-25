//
//  DoubanConnector.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "DoubanConnector.h"
#import "BookDetails.h"
#import "GDataXMLNode.h"
#import "NSString+URLEncoding.h"
#import "BookReviewSummary.h"



@implementation DoubanConnector
static DoubanConnector *doubanConnector;


+ (DoubanConnector *)sharedDoubanConnector{
	if (!doubanConnector) {
		doubanConnector = [[DoubanConnector alloc] init];
	}
	return doubanConnector;
}

- (id)init{
	if (self = [super init]) {
		responseData = [[NSMutableData alloc] init];
		connectionPool = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)removeConnectionWithUUID:(NSString *)uuid{
	DoubanURLConnection *connection = [connectionPool objectForKey:uuid];
	if (connection) {
		[connection cancel];
		[connectionPool removeObjectForKey:uuid];
	}
	if ([connectionPool count] == 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}

//使用豆瓣API，查询图书
- (NSString *)requestQueryBooksWithQueryString:(NSString *)queryString 
                                responseTarget:(id)target 
                                responseAction:(SEL)action{
	NSString *urlString = [NSString stringWithFormat:@"%@?%@&apikey=%@",DOUBAN_BOOK_QUERY_API,queryString,DOUBAN_API_KEY];
    
    NSLog(@"%@", urlString);
    
	return [self sendRequestWithURLString:urlString
                                     type:DOUBAN_BOOKS
                           responseTarget:target
                           responseAction:action];
	
}

//使用isbn查询单本书的详细内容
- (NSString *)requestBookDataWithISBN:(NSString *)isbn 
                       responseTarget:(id)target 
                       responseAction:(SEL)action
{
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?apikey=%@",DOUBAN_BOOK_ISBN_API,isbn,DOUBAN_API_KEY];
	return [self sendRequestWithURLString:urlString
                                     type:DOUBAN_BOOK
                           responseTarget:target
                           responseAction:action];
}

//通过isbn查书评
- (NSString *)requestBookReviewsWithISBN:(NSString *)isbn 
                             queryString:(NSString *)string 
                          responseTarget:(id)target 
                          responseAction:(SEL)action
{
	NSString *urlString = [NSString stringWithFormat:@"http://api.douban.com/book/subject/isbn/%@/reviews?%@&apikey=%@",
						   isbn,string,DOUBAN_API_KEY];
	return [self sendRequestWithURLString:urlString
                                     type:DOUBAN_BOOK_REVIEWS
                           responseTarget:target
                           responseAction:action];
	
}

//提交url请求
- (NSString *)sendRequestWithURLString:(NSString *)urlString
                                  type:(DoubanConnectionType)connectionType 
                        responseTarget:(id)target 
                        responseAction:(SEL)action
{
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad 
											timeoutInterval:30];
	
	//创建本次的请求
	DoubanURLConnection *urlConnection = [[DoubanURLConnection alloc] 
                                          initWithRequest:theRequest delegate:self];
	NSString *uuid = [urlConnection.uuid copy];
	[connectionPool setObject:urlConnection forKey:uuid];
	urlConnection.type = connectionType;
	urlConnection.responseTarget = target;
	urlConnection.responseAction = action;
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //NSLog(@"%@",uuid);
    
	return uuid;
}



#pragma mark 以下全是NSURLConnection的代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{    
	[responseData setLength:0];
    // Get response code.
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [resp statusCode];
	if (statusCode>=400) {		
		NSLog(@"HTTP ERROR ,ERROR CODE: %@",statusCode);
	}
}

//通过该代理，接受返回内容
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    [responseData appendData:data];
}

-(void)connection:(DoubanURLConnection *)connection didFailWithError:(NSError*)error{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:error,@"error",nil];
	
	if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
		[connection.responseTarget performSelector:connection.responseAction withObject:userInfo];
	}
	[self removeConnectionWithUUID:connection.uuid];
}

- (void)connectionDidFinishLoading:(DoubanURLConnection *)connection
{	
	//如果没有返回数据，则直接结束
	if (!responseData || [responseData length] <= 0) {
		return;
	}
    
	if (connection.type == DOUBAN_BOOK) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		BookDetails *book = [BookDetails doubanBookFromXMLElement:rootElement];
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:book,@"book",nil];
		//执行target action
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:userInfo];
		}
		
	}else if (connection.type == DOUBAN_BOOKS) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
        NSLog(@"%@",[[NSString alloc] initWithData:gdataXMLDocument.XMLData encoding:NSUTF8StringEncoding]);
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		NSMutableArray *bookArray = [[NSMutableArray alloc] initWithCapacity:0];
		NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
		NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];
		
		NSArray *bookEntryElements = [rootElement elementsForName:@"entry"];
		for (GDataXMLElement *bookElement in bookEntryElements) {
			[bookArray addObject:[BookDetails doubanBookFromXMLElement:bookElement]];
		}
		//[_delegate didGetDoubanBooks:bookArray withTotalResults:[totalResults intValue] startIndex:[startIndex intValue]];
		//执行target action
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:bookArray,@"books",
								  totalResults,@"totalResults",
								  startIndex,@"startIndex",nil];
		
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction withObject:userInfo];
            
		}
	}else if (connection.type == DOUBAN_BOOK_REVIEWS) {
		NSError *error;
		GDataXMLDocument *gdataXMLDocument = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
		GDataXMLElement *rootElement = [gdataXMLDocument rootElement];
		
		NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
		NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];
        
		NSMutableArray *reviewArray = [[NSMutableArray alloc] initWithCapacity:0];
		NSArray *reviewEntries = [rootElement elementsForName:@"entry"];
		for (GDataXMLElement *reviewElement in reviewEntries) {
			BookReviewSummary *review = [BookReviewSummary bookReviewFromXMLElement:reviewElement];
			[reviewArray addObject:review];
		}
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:reviewArray,@"reviews",
								  totalResults,@"totalResults",
								  startIndex,@"startIndex",nil];
		
		if ([connection.responseTarget respondsToSelector:connection.responseAction]) {
			[connection.responseTarget performSelector:connection.responseAction
											withObject:userInfo];
		}
	}
	
	//移除connection
	[self removeConnectionWithUUID:connection.uuid];
}


@end










/*
 
 
 //使用豆瓣API，查询图书
 - (NSMutableArray *)requestQueryBooksWithQueryString:(NSString *)queryString {
 //设置url
 NSString *urlString = [NSString stringWithFormat:@"%@?%@&apikey=%@",DOUBAN_BOOK_QUERY_API,queryString,DOUBAN_API_KEY];
 
 
 
 NSLog(@"%@",urlString);
 
 
 
 NSURL *url = [NSURL URLWithString:urlString];
 NSMutableURLRequest* request = [NSMutableURLRequest new]; 
 [request setURL:url];  
 [request setHTTPMethod:@"GET"];
 NSHTTPURLResponse* response; 
 NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
 
 NSString* responseXMLResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
 NSError *error;
 
 //得到API返回的XML文档
 GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString: responseXMLResult options:0 error:&error];
 
 if (xmlDoc == nil) { 
 return nil; 
 }
 
 NSLog(@"LOG=%@", [[NSString alloc] initWithData:xmlDoc.XMLData encoding:NSUTF8StringEncoding]);
 
 
 //开始解析XML
 //得到根节点
 GDataXMLElement *rootElement = [xmlDoc rootElement];
 
 NSMutableArray *bookArray = [[NSMutableArray alloc] initWithCapacity:0];
 //取出查询结果总数
 NSString *totalResults = [[[rootElement nodesForXPath:@"//openSearch:totalResults" error:&error] objectAtIndex:0] stringValue];
 
 self.totalBooks = totalResults;
 //取出结果位置索引
 NSString *startIndex = [[[rootElement nodesForXPath:@"//opensearch:startIndex" error:&error] objectAtIndex:0] stringValue];
 //得到装有所有Book的entry数组
 NSArray *bookEntryElements = [rootElement elementsForName:@"entry"];
 //调用方法，将得到的Book装入动态数组
 for (GDataXMLElement *bookElement in bookEntryElements) {
 [bookArray addObject:[BookDetails doubanBookFromXMLElement:bookElement]];
 }
 
 for (BookDetails *book in bookArray) {
 NSLog(@"%@\n",book.title);
 }
 
 NSLog(@"%@",totalResults);
 
 return bookArray;
 }
 
 */



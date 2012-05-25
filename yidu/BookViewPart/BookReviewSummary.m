//
//  BookReviewSummary.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookReviewSummary.h"

@implementation BookReviewSummary

@synthesize updatedTime;
@synthesize authorName;
@synthesize authorIcon;
@synthesize title;
@synthesize summary;

+ (BookReviewSummary *)bookReviewFromXMLElement:(GDataXMLElement *)rootElement{
	BookReviewSummary *bookReview = [[BookReviewSummary alloc] init];
	bookReview.updatedTime = [[[rootElement elementsForName:@"updated"] objectAtIndex:0] stringValue];
	
	GDataXMLElement *authorElement = [[rootElement elementsForName:@"author"] objectAtIndex:0];
	NSArray *authorChildElements = [authorElement elementsForName:@"link"];
	for (GDataXMLElement * childElemtnt in authorChildElements) {
		NSString *relValue = [[childElemtnt attributeForName:@"rel"] stringValue];
		if ([relValue isEqualToString:@"icon"]) {
			bookReview.authorIcon = [[childElemtnt attributeForName:@"href"] stringValue];
		}
	}
	bookReview.authorName = [[[authorElement elementsForName:@"name"] objectAtIndex:0] stringValue];
	
	bookReview.title = [[[rootElement elementsForName:@"title"] objectAtIndex:0] stringValue];
	bookReview.summary = [[[rootElement elementsForName:@"summary"] objectAtIndex:0] stringValue];
	
	return bookReview;
}

@end

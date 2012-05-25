//
//  BookDetails.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookDetails.h"

@implementation BookDetails
@synthesize apiURL;
@synthesize title;
@synthesize	author;
@synthesize summary;
@synthesize alternateURL;
@synthesize coverImageURL;
@synthesize coverLargeImageURL;
@synthesize isbn10;
@synthesize isbn13;
@synthesize pages;
@synthesize tranlator;
@synthesize price;
@synthesize publisher;
@synthesize pubDate;
@synthesize binding;
@synthesize authorIntro;
@synthesize rating;
@synthesize numRaters;

- (NSString *)description{
	return [NSString stringWithFormat:@"Douban Book{title:%@,author:%@,summary:%@,alternateURL:%@,coverImageURL:%@,isbn10:%@,isbn13:%@,pages:%@,tranlator:%@,price:%@,publisher:%@,binding:%@,authorIntro:%@,rating:%@}",
			title,author,summary,alternateURL,coverImageURL,isbn10,isbn13,pages,tranlator,price,publisher,binding,authorIntro,rating];
}


+ (BookDetails *)doubanBookFromXMLElement:(GDataXMLElement *)rootElement{
	BookDetails *book = [[BookDetails alloc] init];
	book.title = [[[rootElement elementsForName:@"title"] objectAtIndex:0] stringValue];
	book.author = [[[[[rootElement elementsForName:@"author"] objectAtIndex:0] elementsForName:@"name"] objectAtIndex:0] stringValue];
	book.summary = [[[rootElement elementsForName:@"summary"] objectAtIndex:0] stringValue];
	NSArray *linkElements = [rootElement elementsForName:@"link"];
	for (GDataXMLElement *linkElement in linkElements) {
		NSString *relValue = [[linkElement attributeForName:@"rel"] stringValue];
		if ([@"self" isEqualToString:relValue]) {
			book.apiURL = [[linkElement attributeForName:@"href"] stringValue];
		}
		if ([@"alternate" isEqualToString:relValue]) {
			book.alternateURL = [[linkElement attributeForName:@"href"] stringValue];
		}
		
		if ([@"image" isEqualToString:relValue]) {
			book.coverImageURL = [[linkElement attributeForName:@"href"] stringValue];
			book.coverLargeImageURL = [book.coverImageURL stringByReplacingOccurrencesOfString:@"spic" withString:@"mpic"];
		}
	}
	
	NSArray *dbElements = [rootElement elementsForName:@"db:attribute"];
	for (GDataXMLElement *dbElement in dbElements) {
		NSString *nameValue = [[dbElement attributeForName:@"name"] stringValue];
		if ([@"isbn10" isEqualToString:nameValue]) {
			book.isbn10 = [dbElement stringValue];
		}
		
		if ([@"isbn13" isEqualToString:nameValue]) {
			book.isbn13 = [dbElement stringValue];
		}
		
		if ([@"pages" isEqualToString:nameValue]) {
			book.pages = [dbElement stringValue];
		}
		
		if ([@"tranlator" isEqualToString:nameValue]) {
			book.tranlator = [dbElement stringValue];
		}
		
		if ([@"price" isEqualToString:nameValue]) {
			book.price = [dbElement stringValue];
		}
		
		if ([@"publisher" isEqualToString:nameValue]) {
			book.publisher = [dbElement stringValue];
		}
		if ([@"pubdate" isEqualToString:nameValue]) {
			book.pubDate = [dbElement stringValue];
		}
		
		if ([@"binding" isEqualToString:nameValue]) {
			book.binding = [dbElement stringValue];
		}	
		
		if ([@"author-intro" isEqualToString:nameValue]) {
			book.authorIntro = [dbElement stringValue];
		}	
	}
	
	GDataXMLElement *ratingElement = [[rootElement elementsForName:@"gd:rating"] objectAtIndex:0];
	if (ratingElement) {
		book.rating = [[ratingElement attributeForName:@"average"] stringValue];
		book.numRaters = [[ratingElement attributeForName:@"numRaters"] stringValue];
	}
	return book;
	
}
@end

//
//  BookDetails.h
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "GDataXMLNode.h"

@interface BookDetails : NSObject

@property(nonatomic,copy) NSString *apiURL;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,copy) NSString *alternateURL;
@property(nonatomic,copy) NSString *coverImageURL;
@property(nonatomic,copy) NSString *coverLargeImageURL;
@property(nonatomic,copy) NSString *isbn10;
@property(nonatomic,copy) NSString *isbn13;
@property(nonatomic,copy) NSString *pages;
@property(nonatomic,copy) NSString *tranlator;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *publisher;
@property(nonatomic,copy) NSString *pubDate;
@property(nonatomic,copy) NSString *binding;
@property(nonatomic,copy) NSString *authorIntro;
@property(nonatomic,copy) NSString *rating;
@property(nonatomic,copy) NSString *numRaters;

+ (BookDetails *)doubanBookFromXMLElement:(GDataXMLElement *)rootElement;
@end


//
//  BookDetailCell.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-16.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookDetailCell.h"
#import "UIImageView+WebCache.h"

@interface BookDetailCell()
- (void)addCoverView;
- (void)addBookAuthorLabel;
- (void)addBookPublisherLabel;
- (void)addBookPubDateLabel;
- (void)addPriceLabel;
- (void)addISBNLabel;
- (void)addRatingView;
@end

@implementation BookDetailCell

@synthesize book;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addCoverView];
		[self addBookAuthorLabel];
		[self addBookPublisherLabel];
		[self addBookPubDateLabel];
		[self addPriceLabel];
		[self addISBNLabel];
		[self addRatingView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBook:(BookDetails *)_book{
	book = _book;
	[coverView setImageWithURL:[NSURL URLWithString:book.coverLargeImageURL]
              placeholderImage:[UIImage imageNamed:@"cover_placeholder.png"]];
	bookAuthorLabel.text = [NSString stringWithFormat:@"作者: %@",book.author];
	priceLabel.text = [NSString stringWithFormat:@"定价: %@",book.price];
	bookPublisherLabel.text = [NSString stringWithFormat:@"出版社: %@",book.publisher];
	bookPubDateLabel.text = [NSString stringWithFormat:@"出版日期: %@",book.pubDate];
	ISBNLabel.text = [NSString stringWithFormat:@"ISBN: %@",book.isbn13];
	ratingView.rating = [book.rating floatValue];
	ratingTailLabel.text = [NSString stringWithFormat:@"(%@,共%@人评分)",book.rating,book.numRaters];
}

- (void)addCoverView{
	CGRect coverViewRect = CGRectMake(8, 8, 90, 130);
	coverView = [[UIImageView alloc] initWithFrame:coverViewRect];
	[self.contentView addSubview:coverView];
	
}

- (void)addBookAuthorLabel{
	CGRect rect = CGRectMake(110, 5, 180, 20);
	bookAuthorLabel = [[UILabel alloc] initWithFrame:rect];
	bookAuthorLabel.textColor = [UIColor darkGrayColor];
	bookAuthorLabel.font = [UIFont systemFontOfSize:14];
    bookAuthorLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:bookAuthorLabel];
	
}

- (void)addBookPublisherLabel{
	CGRect rect = CGRectMake(110, 28, 180, 20);
	bookPublisherLabel = [[UILabel alloc] initWithFrame:rect];
	bookPublisherLabel.textColor = [UIColor darkGrayColor];
    bookPublisherLabel.backgroundColor = [UIColor clearColor];
	bookPublisherLabel.font = [UIFont systemFontOfSize:14];
    
	[self.contentView addSubview:bookPublisherLabel];
	
}

- (void)addBookPubDateLabel{
	CGRect rect = CGRectMake(110, 50, 180, 20);
	bookPubDateLabel = [[UILabel alloc] initWithFrame:rect];
	bookPubDateLabel.textColor = [UIColor darkGrayColor];
    bookPubDateLabel.backgroundColor = [UIColor clearColor];
	bookPubDateLabel.font = [UIFont systemFontOfSize:14];
    
	[self.contentView addSubview:bookPubDateLabel];
}

- (void)addPriceLabel{
	CGRect rect = CGRectMake(110, 72, 180, 20);
	priceLabel = [[UILabel alloc] initWithFrame:rect];
	priceLabel.textColor = [UIColor darkGrayColor];
    priceLabel.backgroundColor = [UIColor clearColor];
	priceLabel.font = [UIFont systemFontOfSize:14];
    
	[self.contentView addSubview:priceLabel];
}

- (void)addISBNLabel{
	CGRect rect = CGRectMake(110, 94, 180, 20);
	ISBNLabel = [[UILabel alloc] initWithFrame:rect];
	ISBNLabel.textColor = [UIColor darkGrayColor];
    ISBNLabel.backgroundColor = [UIColor clearColor];
	ISBNLabel.font = [UIFont systemFontOfSize:14];
    
	[self.contentView addSubview:ISBNLabel];
	
}
- (void)addRatingView{
	ratingView = [[RatingDisplayView alloc] init];
	ratingView.frame = CGRectMake(110, 116,84,16);
	[self.contentView addSubview:ratingView];
	
	ratingTailLabel = [[UILabel alloc] initWithFrame:CGRectMake(196, 116, 100, 20)];
	ratingTailLabel.textColor = [UIColor darkGrayColor];
    ratingTailLabel.backgroundColor = [UIColor clearColor];
	ratingTailLabel.font = [UIFont systemFontOfSize:13];
	[self.contentView addSubview:ratingTailLabel];
}























@end

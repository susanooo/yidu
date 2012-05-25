//
//  BookDetailsViewController.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-19.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "DoubanConnector.h"
#import "BookDetailCell.h"
#import "UIImageView+WebCache.h"
#import "BookReviewsViewController.h"

@interface BookDetailsViewController ()

@end

@implementation BookDetailsViewController
@synthesize detailsTableView;
@synthesize isbn;
@synthesize book;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bookItemNames = [[NSArray alloc] initWithObjects:@"内容简介",@"作者简介",@"查看评论",@"图书比价",nil];
		bookItemImageNames = [[NSArray alloc] initWithObjects:@"info.png",@"author.png",@"comment.png",@"price.png",nil];	
    }
    return self;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
	if (self.isbn) {
		connectionUUID = [[DoubanConnector sharedDoubanConnector] requestBookDataWithISBN:self.isbn
                                                                            responseTarget:self 
                                                                            responseAction:@selector(didGetDoubanBook:)];
		if (HUD == nil) {    
			HUD = [[MBProgressHUD alloc] initWithView:self.view];
			HUD.animationType = MBProgressHUDAnimationZoom;
			HUD.labelText = @"正在加载...";
		}
		
		[self.view addSubview:HUD];
		[HUD show:YES];
	}
}

- (void)viewDidUnload
{
    [self setDetailsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		return 150;
	}else if (indexPath.row ==2) {
        return 30;
    }else if (indexPath.row == 3) {
        NSString *summaryString = [[NSString alloc] initWithFormat:@"  %@",book.summary];
        
        
        UILabel* countHeightLabel = [[UILabel alloc]init];
        countHeightLabel.numberOfLines = 0;
        countHeightLabel.font = [UIFont systemFontOfSize:14];
        countHeightLabel.text = summaryString;
        CGRect rect = [countHeightLabel textRectForBounds:CGRectMake(10, 0, 300, MAXFLOAT) limitedToNumberOfLines:0];
        
        return rect.size.height +36;
    }
	return 38.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.book) {
		return 5;
	}else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *BookTitleCellIdentifier = @"BookTitleCell";
		UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:BookTitleCellIdentifier];
		if (!titleCell) {
			titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BookTitleCellIdentifier];
			titleCell.textLabel.textAlignment = UITextAlignmentCenter;
			titleCell.textLabel.textColor = [UIColor colorWithRed:0.176 green:0.651 blue:0.325 alpha:1.0];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		titleCell.textLabel.text = book.title;
		return titleCell;
		
	}else if (indexPath.row == 1) {
		static NSString *DetailCellIdentifier = @"BookDetailCell";
		BookDetailCell *detailCell = (BookDetailCell *)[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
		if (!detailCell) {
			detailCell = [[BookDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
			detailCell.book = book;
			detailCell.selectionStyle = UITableViewCellSelectionStyleNone;			
		}
		return detailCell;
	}else if (indexPath.row == 2) {
        static NSString *SummaryTitleCellIdentifier = @"SummaryTitleCell";
		UITableViewCell *summaryTitleCell = [tableView dequeueReusableCellWithIdentifier:SummaryTitleCellIdentifier];
		if (!summaryTitleCell) {
			summaryTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SummaryTitleCellIdentifier];
			summaryTitleCell.textLabel.textAlignment = UITextAlignmentLeft;
			summaryTitleCell.textLabel.textColor = [UIColor blackColor];
            summaryTitleCell.textLabel.font = [UIFont systemFontOfSize:15];
            summaryTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
		}
		summaryTitleCell.textLabel.text = @"内容简介：";
		return summaryTitleCell;
    }else if (indexPath.row == 3) {
        static NSString *SummaryCellIdentifier = @"SummaryCell";
		UITableViewCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
		if (!summaryCell) {
			summaryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SummaryCellIdentifier];
			summaryCell.textLabel.textAlignment = UITextAlignmentLeft;
			summaryCell.textLabel.textColor = [UIColor darkGrayColor];
            summaryCell.textLabel.font = [UIFont systemFontOfSize:14];
            summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            summaryCell.textLabel.numberOfLines = 0;
            
		}
        NSString *summaryString;
        if (book.summary == NULL) {
            summaryString = [[NSString alloc] initWithFormat:@"  此书暂无简介！"];
        }else {
            summaryString = [[NSString alloc] initWithFormat:@"  %@",book.summary];
        }
		summaryCell.textLabel.text = summaryString;
		return summaryCell;
    }else {
        static NSString *ReviewsTitleCellIdentifier = @"reviewsTitleCell";
		UITableViewCell *reviewsTitleCell = [tableView dequeueReusableCellWithIdentifier:ReviewsTitleCellIdentifier];
		if (!reviewsTitleCell) {
			reviewsTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReviewsTitleCellIdentifier];
			reviewsTitleCell.textLabel.textAlignment = UITextAlignmentCenter;
			reviewsTitleCell.textLabel.textColor = [UIColor brownColor];
            reviewsTitleCell.textLabel.font = [UIFont systemFontOfSize:15];
            
		}
		reviewsTitleCell.textLabel.text = @"查看评论";
		return reviewsTitleCell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
		BookReviewsViewController *reviewsViewController = [[BookReviewsViewController alloc] initWithNibName:@"BookReviewsViewController" bundle: nil];
		reviewsViewController.isbn = book.isbn13;
		reviewsViewController.navigationItem.title = [NSString stringWithFormat:@"书评:%@",book.title];
		[self.navigationController pushViewController:reviewsViewController animated:YES];
	}
}


#pragma mark -
#pragma mark response action
- (void)didGetDoubanBook:(NSDictionary *)userInfo{
	
	NSError *error = [userInfo objectForKey:@"error"];
	if (error) {
		[HUD removeFromSuperview];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" 
														message:[error localizedDescription]
													   delegate:self 
											  cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	BookDetails *_book = [userInfo objectForKey:@"book"];
	self.book = _book;
	
	[HUD hide:YES];
	[HUD removeFromSuperview];
	
	[detailsTableView reloadData];
	
}






@end

//
//  BookReviewsViewController.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-20.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookReviewsViewController.h"
#import "DoubanConnector.h"
#import "BookReviewSummary.h"
#import <QuartzCore/QuartzCore.h>
#import "ReviewTableViewCell.h"

#define SCORE @"score"
#define TIME  @"time"
#define RESULTS_PER_PAGE 12

@implementation BookReviewsViewController
@synthesize reviewTableView;
@synthesize isbn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        reviews = [[NSMutableArray alloc] init];
		startIndex = 1;
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack. 
		[[DoubanConnector sharedDoubanConnector] removeConnectionWithUUID:connectionUUID];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	[reviews removeAllObjects];
	NSString *queryString = [NSString stringWithFormat:@"start-index=%d&max-results=%d&orderby=%@",startIndex,RESULTS_PER_PAGE,TIME];;
	
	connectionUUID = [[DoubanConnector sharedDoubanConnector] requestBookReviewsWithISBN:isbn 
                                                                              queryString:queryString
                                                                           responseTarget:self 
                                                                           responseAction:@selector(didGetBookReviews:)];
	startIndex += RESULTS_PER_PAGE;
	
	if (HUD == nil) {
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.animationType = MBProgressHUDAnimationZoom;
		HUD.labelText = @"正在加载...";
	}
	[[self view] addSubview:HUD];
	[HUD show:YES];
}

- (void)viewDidUnload{
	self.reviewTableView = nil;
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didGetBookReviews:(NSDictionary *)userInfo{
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
	
	reviewTableView.isLoading = NO;
	totalResults=[[userInfo objectForKey:@"totalResults"] intValue];
	NSArray *bookReviews = [userInfo objectForKey:@"reviews"];
	[reviews addObjectsFromArray:bookReviews];
	
	[HUD hide:YES];
    
	[reviewTableView reloadData];
}


#pragma mark -
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0f;
}


#pragma mark -
#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger resviewCount = [reviews count];
    return resviewCount ? resviewCount + 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if (indexPath.row < [reviews count]) {
		static NSString *CellIdentifier = @"BookReviewCell";
		cell = (ReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell) {
			cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		BookReviewSummary *review = (BookReviewSummary *)[reviews objectAtIndex:indexPath.row];
		((ReviewTableViewCell *)cell).review = review;
	}else {
		if (startIndex > totalResults) {
			reviewTableView.end = YES;
		}else {
			reviewTableView.end = NO;
		}
        
		cell = [reviewTableView dequeueReusableEndCell];
		if (!reviewTableView.isLoading) {
			[self performSelector:@selector(loadMore) withObject:nil afterDelay:0.1];            
		}
	}
    
	
	return cell;
}


#pragma mark -
#pragma mark Load Moew Results
- (void)loadMore {
	if (startIndex > totalResults) {
	}else {
		NSString *queryString = [NSString stringWithFormat:@"start-index=%d&max-results=%d&orderby=%@",startIndex,RESULTS_PER_PAGE,TIME];;
		startIndex += RESULTS_PER_PAGE;
		connectionUUID = [[DoubanConnector sharedDoubanConnector] requestBookReviewsWithISBN:isbn 
                                                                                  queryString:queryString
                                                                               responseTarget:self 
                                                                               responseAction:@selector(didGetBookReviews:)];
		reviewTableView.isLoading = YES;
	}
}


@end

//
//  BookViewController.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-14.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BookViewController.h"
#import "DoubanConnector.h"
#import "BookDetails.h"
#import "BookTableViewCell.h"
#import "ContinuousTableView.h"
#import "NSString+URLEncoding.h"
#import "BookDetailsViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

@synthesize tableData;
@synthesize theSearchBar;
@synthesize textLabel;
@synthesize theTableView;
@synthesize imageView;

@synthesize searchedString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"图书";
        UIImageView *image_map = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"glasses.png"]];
        self.tabBarItem.image=image_map.image;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableData = [[NSMutableArray alloc] initWithCapacity:0];
    self.theTableView.hidden = YES;
    
}

- (void)viewDidUnload
{
    [self.theSearchBar becomeFirstResponder];
    [self setTheTableView:nil];
    [self setTextLabel:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	[tableData removeAllObjects];
	self.searchedString = @"";
	totalResults = 0;
	[theTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//开始进入编辑搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    self.theTableView.allowsSelection = NO;
    self.theTableView.scrollEnabled = NO;
}

//取消搜索时
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString

{

    if (self.tableData.count == 0) {
        
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if( [subview class] == [UILabel class] ) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.font = [UIFont systemFontOfSize:14];
                lbl.text = @"完成输入后请点击‘搜索’按钮！";
                
            }
            
        }
        
    }
    
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
    
}

//执行搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
    self.searchedString = searchBar.text;
	startIndex = 1;
	totalResults = 0;
	if (!self.searchedString || [self.searchedString isEqualToString:@""]) {
		[tableData removeAllObjects];
		[theTableView reloadData];
		return;
	}
	NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchedString urlEncodeString]
							 ,startIndex,MAX_RESULTS];
	startIndex += MAX_RESULTS;
    
    [[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
															   responseTarget:self 
															   responseAction:@selector(didGetDoubanBooks:)];
    
    [[self searchDisplayController] setActive:NO animated:YES];
	if (HUD == nil) {
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.animationType = MBProgressHUDAnimationZoom;
		HUD.labelText = @"正在加载...";
	}
	[[self view] addSubview:HUD];
	[HUD show:YES];
	[tableData removeAllObjects];
}

#pragma mark UITableViewDataSource Methods
//设置tableView的行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //如果结果数为0，则返回0，否则返回结果数加1，多出来的一行是放加载标识的
	NSInteger resultCount = [tableData count];
    return resultCount ? resultCount + 1 : resultCount;
}

//设置每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0f;
}

//设置tableView
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [tableData count]) {
		static NSString *CellIdentifier = @"BookCell";
		BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		BookDetails *book = (BookDetails *)[tableData objectAtIndex:indexPath.row];
		cell.book = book;
		return cell;
	}else {
		UITableViewCell *endCell = [theTableView dequeueReusableEndCell];
		if (!theTableView.isLoading) {
            [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.1];            
        }
		return endCell;
	}
}

#pragma mark -
#pragma mark UITableView Delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.row < [tableData count]) {
		NSString *isbnString = ((BookDetails *)[tableData objectAtIndex:indexPath.row]).isbn13;
        
        NSLog(@"ISBN = %@",isbnString);
        
		BookDetailsViewController *bookDetailsViewController = [[BookDetailsViewController alloc] initWithNibName:@"BookDetailsViewController" bundle:nil];	
        bookDetailsViewController.title = @"图书详情";
		bookDetailsViewController.isbn = isbnString;

		[self.navigationController pushViewController:bookDetailsViewController animated:YES];
	}
}

#pragma mark 获得加载更多的结果
- (void)loadMore {
	if (startIndex > totalResults) {
	}else {
		NSString *queryString = [NSString stringWithFormat:@"q=%@&start-index=%d&max-results=%d",[self.searchedString urlEncodeString],startIndex,MAX_RESULTS];
		startIndex += MAX_RESULTS;
		[[DoubanConnector sharedDoubanConnector] requestQueryBooksWithQueryString:queryString
																   responseTarget:self
																   responseAction:@selector(didGetDoubanBooks:)];
		theTableView.isLoading = YES;
	}
}




#pragma mark 通过代理，得到所有Book的数组，并添加到tableData数据源中
- (void)didGetDoubanBooks:(NSDictionary *)userInfo{
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
	theTableView.isLoading = NO;
	totalResults=[[userInfo objectForKey:@"totalResults"] intValue];
	NSArray *books = [userInfo objectForKey:@"books"];
    
	[HUD hide:YES];
	[HUD removeFromSuperview];
	for (BookDetails* book in books) {
		[tableData addObject:book];
	}
	if (startIndex > totalResults) {
		theTableView.end = YES;
	}else {
		theTableView.end = NO;
	}
    
    self.theTableView.hidden = NO;
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
    self.textLabel.hidden = YES;
    self.imageView.hidden = YES;
	[theTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	
}


@end

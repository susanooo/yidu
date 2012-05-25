//
//  aboutViewController.m
//  yidu
//
//  Created by 智超 常 on 12-5-7.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController
@synthesize aboutTableView;

- (id)init{
	if (self = [super initWithNibName:@"aboutViewController" bundle:nil]) {
		NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
		dataArray = [[NSArray alloc] initWithObjects:
					 [NSArray arrayWithObjects:[NSString stringWithFormat:@"软件版本: %@",version],
                      @"数据来源: 豆瓣网",
                      @"联系邮箱: kejinlu@gmail.com",
                      @"作者主页: http://geeklu.com",nil],
					 nil];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIndentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.textLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	return cell;
}


@end

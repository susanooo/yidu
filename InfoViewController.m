//
//  InfoViewController.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "InfoViewController.h"
#import "aboutViewController.h"
#import "describeViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize moreTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *image_info = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"idCard.png"]];
        self.title = @"信息";
        self.tabBarItem.image = image_info.image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]initWithObjects:[NSArray arrayWithObjects:@"关于我们",@"软件说明",@"问题反馈",nil],nil];
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
//必须实现的三个方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dataArray objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            //关于我们
            aboutViewController *aboutView = [[aboutViewController alloc] init];
            [self.navigationController pushViewController:aboutView animated:YES];
            
        }
        if (indexPath.row == 1) {
            //软件说明
            describeViewController *describeView = [[describeViewController alloc]init];
            [self.navigationController pushViewController:describeView animated:YES];
        }
        if (indexPath.row == 2) {
            Class mail = (NSClassFromString(@"MFMailComposeViewController"));
            if (mail) {
                if ([mail canSendMail]) {
                    [self displayComposerSheet];
                }
                else {
                    [self launchMailAppOnDevice];
                }
            }
            else {
                [self launchMailAppOnDevice];
            }
        }
    }
}

#pragma mark Mail
- (void)displayComposerSheet {
   	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setToRecipients:[NSArray arrayWithObjects:@"amberchiong@gmail.com",nil]];
	[controller setSubject:@"问题反馈"];
	[controller setMessageBody:@"你的意见对我很重要" isHTML:NO];
	[self presentModalViewController:controller animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self becomeFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
    [moreTableView deselectRowAtIndexPath:[moreTableView indexPathForSelectedRow] animated:YES];
}

- (void)launchMailAppOnDevice {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto:amberchiong@gmail.com"]];
}

@end

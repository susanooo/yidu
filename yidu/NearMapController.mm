//
//  NearMapController.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "NearMapController.h"


@implementation NearMapController
@synthesize mapViewController;
@synthesize poiResult;
@synthesize poiResultDic;
@synthesize testArray;
@synthesize _hudView;
@synthesize _activityIndicatorView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    
    /*
    //构造等待风火轮
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 5.0;
    [_hudView setTag:777];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    [_hudView addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    UILabel *_captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.adjustsFontSizeToFitWidth = YES;
    _captionLabel.textAlignment = UITextAlignmentCenter;
    _captionLabel.text = @"Loading...";
    [_hudView addSubview:_captionLabel];
    
    [self.view addSubview:_hudView];
    
    [self performSelector:@selector(killActivity:) withObject:_activityIndicatorView afterDelay:10.0];
    */
       
    [NSThread detachNewThreadSelector:@selector(sleepThread) toTarget:self withObject:nil];
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



- (void)tableShow
{

    [mapViewController.view removeFromSuperview];
    CATransition *animation = [CATransition animation]; 
    animation.duration = 0.75f; 
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; 
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    

}

#pragma mark-
#pragma tableView必须实现的三个方法

//分多少块section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//用来查看分区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [testArray count];
}
//绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableId = @"tableID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableId];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableId];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [testArray objectAtIndex:row];    //设置cell中的数据
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15]; //设者cell中字体的大小

    return cell;
    
}
- (void)killActivity:(UIActivityIndicatorView *)activity{
    UIView *view = (UIView *)[self.view viewWithTag:777];
    [view removeFromSuperview];
    [_activityIndicatorView stopAnimating];
}


@end

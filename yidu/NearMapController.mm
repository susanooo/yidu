//
//  NearMapController.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "NearMapController.h"


@implementation NearMapController
@synthesize select;
@synthesize mapViewController;
@synthesize resultTable;
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
        UIImageView *image_map = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker.png"]];
        self.title = @"附近";
        self.tabBarItem.image=image_map.image;
    }
    return self;
}

- (void)viewDidLoad
{
        
    self.mapViewController = [[MapViewController alloc]init];
    mapViewController.key = @"图书馆";
    [self.view addSubview:mapViewController.view];
    testArray = [[NSMutableArray alloc]init];
    
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
    
    UIBarButtonItem *map =[[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target: self action:@selector(mapShow)];

    self.navigationItem.rightBarButtonItem = map;
    
    self.select = [[UISegmentedControl alloc] init];
    select.frame = CGRectMake(80, 7, 160, 30);

    [select insertSegmentWithTitle:@"图书馆" atIndex:0 animated:YES];
    [select insertSegmentWithTitle:@"cafe" atIndex:1 animated:YES];
    [select insertSegmentWithTitle:@"书店" atIndex:2 animated:YES];
    select.segmentedControlStyle = UISegmentedControlStyleBar;
    select.momentary = NO;
    select.multipleTouchEnabled=NO;
    select.selectedSegmentIndex = 0;
    [select addTarget:self action:@selector(changeKey) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = select;
    
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


- (void)mapShow
{
    [UIView beginAnimations:nil context:nil];//动画开始
    
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mapViewController.view cache:YES];
    [UIView commitAnimations];
    [self.view addSubview:mapViewController.view];

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
- (void)changeKey
{
    if (self.select.selectedSegmentIndex == 0) {
        NSLog(@"图书馆！！！");
        mapViewController.key=@"图书馆";
        [NSThread detachNewThreadSelector:@selector(sleepThread) toTarget:self withObject:nil];

    }
    if (self.select.selectedSegmentIndex == 1) {
        NSLog(@"cafe！！！");
        mapViewController.key=@"cafe";
        [NSThread detachNewThreadSelector:@selector(sleepThread) toTarget:self withObject:nil];
    }
    if (self.select.selectedSegmentIndex == 2) {
        NSLog(@"书店！！！");
        mapViewController.key=@"书店";
        [NSThread detachNewThreadSelector:@selector(sleepThread) toTarget:self withObject:nil];
    }
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
- (void)getPoiValue
{   
    

    if (@"cafe" == mapViewController.key) {
        poiResult = mapViewController.cafeResult;
    }
    if (@"书店" == mapViewController.key) {
        poiResult = mapViewController.bSResult;
    }
    else {
        poiResult = mapViewController.libResult;
    }

    BMKPoiResult* result = [poiResult objectAtIndex:0];
    for (int i= 0;i < result.poiInfoList.count; i++) {
        BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
        [testArray addObject:poi.name];
        NSLog(@"%@",[testArray objectAtIndex:i]);
    }

    [resultTable reloadData];
}
- (void)sleepThread
{
    sleep(5);
    [self performSelectorOnMainThread:@selector(getPoiValue) withObject:nil waitUntilDone:NO];
}

@end

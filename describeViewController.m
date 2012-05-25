//
//  describeViewController.m
//  yidu
//
//  Created by 智超 常 on 12-5-7.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "describeViewController.h"

@interface describeViewController ()

@end

@implementation describeViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 406)];
	textView.backgroundColor = [UIColor whiteColor];
	textView.editable = NO;
	textView.text = @"    本软件的数据来源于豆瓣，数据的使用遵守“豆瓣API使用条款”，比价购书直达链接和豆瓣比价页面中的链接保持一致，购书行为与本软件以及Apple Inc.没有任何联系，特此说明。";
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:16];
	[self.view addSubview:textView];
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

@end

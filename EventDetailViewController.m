//
//  EventDetailViewController.m
//  yidu
//
//  Created by Liu Di on 6/4/12.
//  Copyright (c) 2012 広島大学. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize eventTitle,eventContent,contentTextView;

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
    contentTextView.text = eventContent;
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

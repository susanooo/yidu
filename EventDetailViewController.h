//
//  EventDetailViewController.h
//  yidu
//
//  Created by Liu Di on 6/4/12.
//  Copyright (c) 2012 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController {
    NSString *eventTitle;
    NSString *eventContent;
    IBOutlet UITextView *contentTextView;
}

@property(retain,nonatomic) NSString *eventTitle;
@property(retain,nonatomic) NSString *eventContent;
@property(retain,nonatomic) IBOutlet UITextView *contentTextView;
@end

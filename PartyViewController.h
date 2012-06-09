//
//  PartyViewController.h
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XMLParser.h"
#import "GDataXMLNode.h"
#import "EventDetailViewController.h"
#define DOUBAN_EVENTS_OF_CITY @"http://api.douban.com/event/location/"


@interface PartyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    //IBOutlet UIWebView *webView;
    //XMLParser *_xmlParser;
    NSMutableArray *_eventsArray; //Array to save all the events get from XML. Data type of each each event is supposed to be GDataXMLElement
    NSMutableArray *_eventsTitleList; // Array to save all the titles of event
    NSMutableArray *_eventsContentArray; //array to save the contents of all the events
    //IBOutlet UITableView *tableView;
    //UINavigationController *navigationController;
}



//@property (strong, nonatomic) UIWebView *webView;
//@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) UINavigationController *navigationController;
//@property (strong, nonatomic) XMLParser *_xmlParser;
@property (strong, nonatomic) NSMutableArray *_eventsArray;
@property (strong, nonatomic) NSMutableArray *_eventsTitleList;
@property (strong, nonatomic) NSMutableArray *_eventsContentArray;

-(void) createEvent;
- (void)retrieveEventsOfCity:(NSString *)city;

@end

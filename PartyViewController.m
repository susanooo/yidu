//
//  PartyViewController.m
//  yidu
//
//  Created by 智超 常 on 12-3-21.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "PartyViewController.h"

@interface PartyViewController ()
//-(void) createEvent;
@end



@implementation PartyViewController
//@synthesize _xmlParser
//@synthesize navigationController;
@synthesize _eventsArray, _eventsTitleList, _eventsContentArray;


-(void)createEvent {
   /*
    NSString *urlAddress = @"http://api.douban.com/events";
    NSURL *myURL = [NSURL URLWithString:urlAddress];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    
    //[request setURL:[NSURL URLWithString:@"http://api.douban.com/events"]];
    [request setHTTPMethod:@"POST"];
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(data);
    */
    
    NSString * xmlString = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<entry xmlns=\"http://www.w3.org/2005/Atom\" xmlns:db=\"http://www.douban.com/xmlns/\" xmlns:gd=\"http://schemas.google.com/g/2005\" xmlns:opensearch=\"http://a9.com/-/spec/opensearchrss/1.0/\">\n<title>Comme des Garçons 展览会 </title>\n<category scheme=\"http://www.douban.com/2007#kind\" term=\"http://www.douban.com/2007#event.exhibit\"/>\n<content>This is a Test </content></entry>"];
    NSLog(xmlString);
    NSURL * serviceUrl = [NSURL URLWithString:@"http://api.douban.com/events"];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[xmlString dataUsingEncoding:NSASCIIStringEncoding]];

    
    NSURLResponse * serviceResponse;
    NSError * serviceError;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&serviceResponse error:&serviceError];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(data);
    
}

//Retrieve all the events in a city and return an array of events 
- (void)retrieveEventsOfCity:(NSString *)city {
    //设置url
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOUBAN_EVENTS_OF_CITY,city];
    
    NSLog(@"%@",urlString);
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest new]; 
    [request setURL:url];  
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse* response; 
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* responseXMLResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    //得到API返回的XML文档
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString: responseXMLResult options:0 error:&error];
    
    if (xmlDoc == nil) { 
        NSLog(@"xcl document is null"); 
    }
    
    //NSLog(@"LOG=%@", [[NSString alloc] initWithData:xmlDoc.XMLData encoding:NSUTF8StringEncoding]);
    
    
    //开始解析XML
    //得到根节点
    GDataXMLElement *rootElement = [xmlDoc rootElement];
    
    //NSMutableArray *eventsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //NSMutableArray *eventTitlesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //Get the array contains all the events
    self._eventsTitleList = [[NSMutableArray alloc] init];
    self._eventsContentArray = [[NSMutableArray alloc] init];
    self._eventsArray = [[NSMutableArray alloc] init];
    //save events to array
    [self._eventsArray addObjectsFromArray: [rootElement elementsForName:@"entry"]];
    NSLog(@"_eventsArray count:%d",[_eventsArray count]);
    
    for (GDataXMLElement *eventEntryElement in _eventsArray) {
        //[eventsArray addObject:eventEntryElement];
        //NSLog(@"%@\n\n\n\n",eventEntryElement);
        NSLog(@"%@",[[[eventEntryElement elementsForName:@"Title"] objectAtIndex:0] stringValue]);
    }
    
    for (int i=0; i<[_eventsArray count]; i++) {
        NSArray *eventTitleElements = [[_eventsArray objectAtIndex:i] elementsForName:@"title"];
        NSArray *eventContentElements = [[_eventsArray objectAtIndex:i] elementsForName:@"content"];
        NSLog(@"eventTitleElements count:%d",[eventTitleElements count]);
        NSLog(@"eventContentElements count:%d",[eventContentElements count]);
        //save titles of all the events to array
        for (GDataXMLElement *eventTitleElement in eventTitleElements) {
            NSLog(@"%@",[eventTitleElement stringValue]);
            
            [_eventsTitleList addObject:[eventTitleElement stringValue]];
        }
        //save contents of all the events to array
        for (GDataXMLElement *eventContentElement in eventContentElements) {
            //NSLog(@"%@",[eventContentElement stringValue]);
            [_eventsContentArray addObject:[eventContentElement stringValue]];
        }
        
        NSLog(@"eventsContentArray count:%d",[_eventsContentArray count]);
    }
    
    
    //NSLog(@"title count:%d",[[[eventsArray objectAtIndex:0] elementsForName:@"title"] count]);
    //return eventEntryElements;
    //return eventsArray;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"活动";
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    //numbers of table cells equal to number of events
    return [_eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    //cell.textLabel.text = @"text";
    //cell.textLabel.text = [[[[_eventsArray objectAtIndex:[indexPath row]] elementsForName:@"title"] objectAtIndex:0]stringValue];
    //set cell content as the event title
    cell.textLabel.text = [self._eventsTitleList objectAtIndex:[indexPath row]];
    
    return cell;
} 

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];	
    eventDetailViewController.title = @"活动详情";
    eventDetailViewController.eventTitle = [self._eventsTitleList objectAtIndex:[indexPath row]];
    eventDetailViewController.eventContent = [self._eventsContentArray objectAtIndex:[indexPath row]];
    /*
     if ([self._eventsTitleList objectAtIndex:[indexPath row]]) {
     NSLog(@"%@",[self._eventsTitleList objectAtIndex:[indexPath row]]);
     }
     
     if ([self._eventsContentArray objectAtIndex:[indexPath row]]) {
     NSLog(@"%@",[self._eventsTitleList objectAtIndex:[indexPath row]]);
     }
     else {
     NSLog(@"eventContent is null");
     }
     */
    [self.navigationController pushViewController:eventDetailViewController animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setup the navigation bar items
    UIBarButtonItem *naviBarEvents =[[UIBarButtonItem alloc]initWithTitle:@"发起活动" style:UIBarButtonItemStylePlain target: self action:@selector(createEvent)];
    self.navigationItem.rightBarButtonItem = naviBarEvents;
    
    //retrive all the events from city "beijing"
    [self retrieveEventsOfCity:@"beijing"];
    //NSLog(@"eventArray count:%d",[_eventsArray count]);
    //NSLog(@"titles count:%d",[[[_eventsArray objectAtIndex:0] elementsForName:@"title"] count] );
    //NSArray *eventTitleElements = [[_eventsArray objectAtIndex:0] elementsForName:@"title"];
    //for (GDataXMLElement *eventTitleElement in eventTitleElements) {
    
    //NSLog(@"%@",[eventTitleElement stringValue]);
    //}
    
    //NSLog(@"title count:%d",[[[[_eventsArray objectAtIndex:0] elementsForName:@"title"] objectAtIndex:0] count]);

    
    
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

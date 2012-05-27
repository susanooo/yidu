//
//  mapSearchControllerViewController.m
//  yidu
//
//  Created by Chiong Amber on 12-5-26.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "mapSearchControllerViewController.h"

@interface mapSearchControllerViewController ()

@end

@implementation mapSearchControllerViewController

@synthesize searchBar;
@synthesize displayController;
@synthesize allItems;
@synthesize searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"搜索界面");
    
    self.tableView.scrollEnabled = YES;
    NSArray *items = [[NSArray alloc] initWithObjects:@"Code Geass",@"Asura Cryin'",@"Voltes V",                       @"Mazinger Z",@"Daimos",nil]; 
    self.allItems = items;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 46, 320, 44)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
    self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.tableView.tableHeaderView = self.searchBar;
    
    displayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    displayController.searchResultsDataSource = self;
    displayController.searchResultsDelegate = self;
    
    [self.tableView addSubview:self.displayController.searchResultsTableView];
    [self.tableView reloadData];
    
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView   numberOfRowsInSection:(NSInteger)section {  
    
    NSInteger rows = 0;    
    
    if ([tableView isEqual:self.displayController.searchResultsTableView]){      
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSString *fontName in self.searchResults) {
            if([fontName hasPrefix:self.displayController.searchBar.text])
            {
                [tempArray addObject:fontName];  
            }
        }
        self.searchResults = [NSArray arrayWithArray:tempArray];
        
        rows = [self.searchResults count];  
        
    }else{     
        
        rows = [self.allItems count];    
        
    }    
    
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell";   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    if (cell == nil) {  
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier];    
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        
    }   
    
    /* Configure the cell. */ 
    
    if ([self.tableView isEqual:self.displayController.searchResultsTableView]){    
        
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        
    }else{ 
        
        cell.textLabel.text = [self.allItems objectAtIndex:indexPath.row]; 
        
    }   
    
    return cell;
    
}  

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope { 
    
    //[self.searchResults removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    self.searchResults = [self.allItems filteredArrayUsingPredicate:resultPredicate];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString { 
    
    [self filterContentForSearchText:searchString scope:[[self.displayController.searchBar scopeButtonTitles] objectAtIndex:[self.displayController.searchBar selectedScopeButtonIndex]]];  
    
    return YES;
    
}  

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption { 
    
    [self filterContentForSearchText:[self.displayController.searchBar text]                             scope:[[self.displayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];  
    
    return YES;
    
}



@end

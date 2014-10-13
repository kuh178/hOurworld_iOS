//
//  MTBChooseMemberViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBChooseMemberViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBChooseMemberViewController ()

@end

@implementation MTBChooseMemberViewController
@synthesize jsonArray, tableViewList, searchBar;
@synthesize searchResult;
@synthesize searchDisplayController;
NSArray *sortedArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    searchBar.delegate = self;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SearchBioViewController";
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == searchDisplayController.searchResultsTableView) {
        
        NSLog(@"searchResult : %d", [searchResult count]);
        
        return [searchResult count];
    }
    else {
        return [sortedArray count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    // Note: for searchbar function, it is important to use "tableViewList" not "tableView"
    UITableViewCell *cell = [tableViewList dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // display items
    NSDictionary *item = [[NSDictionary alloc] init];
    
    if (tableView == searchDisplayController.searchResultsTableView) {
        item = [searchResult objectAtIndex:indexPath.row];
        
        NSLog(@"item : %@", item);
        
    }
    else {
        item = [sortedArray objectAtIndex:indexPath.row];
    }
    
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", [[item objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [[item objectForKey:@"Lname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]);
    
    // user name
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@", [[item objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [[item objectForKey:@"Lname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item;
    
    if (tableView == searchDisplayController.searchResultsTableView) {
        item = [searchResult objectAtIndex:indexPath.row];
        
    }
    else {
        item = [sortedArray objectAtIndex:indexPath.row];
    }

    [self.delegate addItemViewController:self didFinishEnteringItem:item];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Choose Member"];
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"getMbrs,0"],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    jsonArray = [NSMutableArray arrayWithCapacity:0];
    searchResult = [NSMutableArray arrayWithCapacity:0];
    [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];

    sortedArray = [jsonArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *Fname1 = [[a objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *Fname2 = [[b objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [Fname1 compare:Fname2];
    }];

    [tableViewList reloadData];
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", operation);
}];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.Fname contains[c] %@ OR SELF.Lname contains[c] %@", searchText, searchText];
    searchResult = [NSMutableArray arrayWithArray:[jsonArray filteredArrayUsingPredicate:resultPredicate]];
    
    NSLog(@"%d, %d", [jsonArray count], [searchResult count]);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

@end

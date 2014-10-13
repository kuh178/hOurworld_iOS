//
//  MTBSubCategoryViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBSubCategoryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "MTBFinalTaskPostViewController.h"

@interface MTBSubCategoryViewController ()

@end

@implementation MTBSubCategoryViewController

@synthesize scheduleList, jsonArray, tableViewList;
@synthesize svcCat, svcCatID, isOffer, isRequest;
@synthesize serviceCategory, stepLabel;

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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if ([svcCat isEqualToString:@"0 Account Management"]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"No results found."];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else {
        [serviceCategory setText:[NSString stringWithFormat:@"Picked category : %@", svcCat]];
        [self downloadContent];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SubCategoryViewController"; 
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
    return [jsonArray count];
}


// ref: http://www.colejoplin.com/2012/09/28/ios-tutorial-basics-of-table-views-and-prototype-cells-in-storyboards/
// ref2:http://www.appcoda.com/ios-programming-customize-uitableview-storyboard/
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *categoryText = (UILabel *)[cell viewWithTag:100];
    
    // display category texts
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    [categoryText setText:[item objectForKey:@"Service"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];

	MTBFinalTaskPostViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBFinalTaskPostViewController"];
	[viewController setSvcCat:svcCat];
    [viewController setSvcCatID:svcCatID];
	[viewController setService:[item objectForKey:@"Service"]];
    [viewController setSvcID:[[item objectForKey:@"SvcID"] intValue]];
    [viewController setIsOffer:isOffer];
    [viewController setIsRequest:isRequest];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:@"2nd step (2/3)"];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if([isOffer isEqualToString:@"T"]) {
        stepLabel.text = @"Pick a service category for your offer";
    }
    else {
        stepLabel.text = @"Pick a service category for your request";
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSDictionary *params = @{@"requestType"     :@"AddTask,SVC",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"SvcCatID"        :[NSString stringWithFormat:@"%d", svcCatID]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              jsonArray = [NSMutableArray arrayWithCapacity:0];
              scheduleList = [NSMutableArray arrayWithCapacity:0];
              
              if ([[responseObject objectForKey:@"results"] isEqual:(id)[NSNull null]]) {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"No results found."];
                  [dialog addButtonWithTitle:@"OK"];
                  [dialog show];
              }
              else {
                  [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];   
                  [tableViewList reloadData];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end

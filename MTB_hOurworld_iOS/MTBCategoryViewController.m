//
//  MTBCategoryViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBCategoryViewController.h"
#import "MTBSubCategoryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBCategoryViewController ()

@end

@implementation MTBCategoryViewController

@synthesize scheduleList, jsonArray, tableViewList;
@synthesize isOffer, isRequest;
@synthesize stepLabel;

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
    
    NSLog(@"%@", isOffer);
    NSLog(@"%@", isRequest);
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"CategoryViewController";
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
    [categoryText setText:[item objectForKey:@"SvcCat"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
	MTBSubCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBSubCategoryViewController"];
	[viewController setSvcCat:[item objectForKey:@"SvcCat"]];
    [viewController setSvcCatID:[[item objectForKey:@"SvcCatID"] intValue]];
    [viewController setIsOffer:isOffer];
    [viewController setIsRequest:isRequest];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)updateTimeLine {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"1st step (1/3)";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if([isOffer isEqualToString:@"T"]) {
        stepLabel.text = @"Pick a category for your offer";
    }
    else {
        stepLabel.text = @"Pick a category for your request";
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
    
    NSDictionary *params = @{@"requestType"     :@"AddTask,CAT",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              jsonArray = [NSMutableArray arrayWithCapacity:0];
              scheduleList = [NSMutableArray arrayWithCapacity:0];
              
              [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
              
              [tableViewList reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end

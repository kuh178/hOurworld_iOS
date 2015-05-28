//
//  MTBReportHourTaskCategoryServiceViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBReportHourTaskCategoryServiceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBItem.h"
#import "MTBTaskDetailViewController.h"
#import "MTBCategoryViewController.h"
#import "MTBProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MTBReportHourTaskCategoryServiceViewController ()

@end

@implementation MTBReportHourTaskCategoryServiceViewController

@synthesize jsonArray, tableViewList;
@synthesize svcCat, svcCatID;

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
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
        [dialog show];
    }
    else {
        [self downloadContent];
    }
    
    NSLog(@"serviceCatID: %ld", (long)svcCatID);
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

    [self.delegate addServiceViewController:self didFinishEnteringItem:svcCat SvcCatID:(int)svcCatID Service:[item objectForKey:@"Service"] SvcID:[[item objectForKey:@"SvcID"] intValue]];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Pick_Service_Category", nil)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc]
                                      initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)]
                                      style: UIBarButtonItemStyleBordered
                                      target:nil
                                      action:nil];
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
                             @"SvcCatID"        :[NSString stringWithFormat:@"%ld", (long)svcCatID]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    jsonArray = [NSMutableArray arrayWithCapacity:0];

    if ([[responseObject objectForKey:@"results"] isEqual:(id)[NSNull null]]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
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

//
//  MTBTaskCategoryServiceViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/17/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBTaskCategoryServiceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "MTBTaskCategoryServiceTaskViewController.h"
#import "MTBCategoryViewController.h"

@interface MTBTaskCategoryServiceViewController ()

@end

@implementation MTBTaskCategoryServiceViewController

@synthesize scheduleList, jsonArray, tableViewList;
@synthesize svcCat, svcCatID, service, svcID, isOffer, isRequest;
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
    
    NSLog(@"%@", isOffer);
    NSLog(@"%@", isRequest);
    
    if ([svcCat isEqualToString:@"0 Account Management"]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
        [dialog show];
    }
    else {
        [serviceCategory setText:[NSString stringWithFormat:@"Picked category : %@", svcCat]];
        [self downloadContent];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MTBTaskCategoryServiceViewController";
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
    [categoryText setText:[NSString stringWithFormat:@"%@ (%d)", [item objectForKey:@"Service"], [[item objectForKey:@"Count"] intValue]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // MTBTaskCategoryServiceTaskViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBTaskCategoryServiceTaskViewController"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBTaskCategoryServiceTaskViewController"]) {
        
        NSIndexPath *indexPath = [self.tableViewList indexPathForCell:sender];
        NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
        
        MTBTaskCategoryServiceTaskViewController *viewController = (MTBTaskCategoryServiceTaskViewController *)[segue destinationViewController];
        
        [viewController setSvcCat:svcCat];
        [viewController setSvcCatID:svcCatID];
        [viewController setService:[item objectForKey:@"Service"]];
        [viewController setSvcID:[[item objectForKey:@"SvcID"] intValue]];
        [viewController setIsOffer:isOffer];
        [viewController setIsRequest:isRequest];
        //[self.navigationController pushViewController:viewController animated:YES];
        
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Pick_service", nil)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if([isOffer isEqualToString:@"T"]) {
        stepLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick_service_offer", nil)];
    }
    else {
        stepLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick_service_request", nil)];
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)] style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    // start downloading
    
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params;
    
    if ([isOffer isEqualToString:@"T"]) {
        
        params = @{@"requestType"     :[NSString stringWithFormat:@"OfferCatsC,%ld",(long)svcCatID],
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"],
                   @"SvcCatID"        :[NSString stringWithFormat:@"%ld", (long)svcCatID]};
    }
    else {
        
        params = @{@"requestType"     :[NSString stringWithFormat:@"RequestCatsC,%ld",(long)svcCatID],
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"],
                   @"SvcCatID"        :[NSString stringWithFormat:@"%ld", (long)svcCatID]};
    }
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
              jsonArray = [NSMutableArray arrayWithCapacity:0];
              scheduleList = [NSMutableArray arrayWithCapacity:0];
              
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
                  
                  // sort the categoryList : http://stackoverflow.com/questions/805547/how-to-sort-an-nsmutablearray-with-custom-objects-in-it
                  NSArray *sortedArray;
                  sortedArray = [jsonArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                      return [[a objectForKey:@"SvcCat"] compare:[b objectForKey:@"SvcCat"]];
                  }];
                  [jsonArray removeAllObjects];
                  [jsonArray addObjectsFromArray:sortedArray];
                  
                  [tableViewList reloadData];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end

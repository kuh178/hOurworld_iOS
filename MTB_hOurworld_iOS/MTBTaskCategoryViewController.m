//
//  MTBTaskCategoryViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/17/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBTaskCategoryViewController.h"
#import "MTBTaskCategoryServiceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTBCategoryViewController.h"
#import "JSON.h"

@interface MTBTaskCategoryViewController ()

@end

@implementation MTBTaskCategoryViewController

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
    self.screenName = @"MTBTaskCategoryViewController";
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
    [categoryText setText:[NSString stringWithFormat:@"%@", [item objectForKey:@"SvcCat"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // MTBTaskCategoryServiceViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBTaskCategoryServiceViewController"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBTaskCategoryServiceViewController"]) {
        
        NSIndexPath *indexPath = [self.tableViewList indexPathForCell:sender];
        NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
        
        MTBTaskCategoryServiceViewController *viewController = (MTBTaskCategoryServiceViewController *)[segue destinationViewController];
        [viewController setSvcCat:[item objectForKey:@"SvcCat"]];
        [viewController setSvcCatID:[[item objectForKey:@"SvcCatID"] intValue]];
        [viewController setService:[item objectForKey:@"Service"]];
        [viewController setSvcID:[[item objectForKey:@"SvcID"] intValue]];
        [viewController setIsOffer:isOffer];
        [viewController setIsRequest:isRequest];
        //[self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)updateTimeLine {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Pick a category";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
    
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params;
    
    if ([isOffer isEqualToString:@"T"]) {
        
        params = @{@"requestType"     :@"OfferCats,0",
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"]};
    }
    else {
        
        params = @{@"requestType"     :@"RequestCats,0",
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"]};
    }
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            if ([responseObject isEqual:[NSNull null]]) {
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:@"Cannot get the data from the server. (If you see this message multiple times, try logout and re-login)"];
                [dialog addButtonWithTitle:@"OK"];
                [dialog show];
            }
            else {
                jsonArray = [NSMutableArray arrayWithCapacity:0];
                scheduleList = [NSMutableArray arrayWithCapacity:0];
                
                if ([responseObject isEqual:[NSNull null]]) {
                    UIAlertView *dialog = [[UIAlertView alloc]init];
                    [dialog setDelegate:nil];
                    [dialog setTitle:@"Message"];
                    [dialog setMessage:@"Cannot get the data from the server. Please try again."];
                    [dialog addButtonWithTitle:@"OK"];
                    [dialog show];
                }
                else {
                    NSLog(@"responseObject : %@", responseObject);
                    
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
            }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end

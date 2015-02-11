//
//  MTBGroupViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBGroupViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "MTBGroupDetailViewController.h"
#import "MTBGroupMessageViewController.h"

@interface MTBGroupViewController ()

@end

@implementation MTBGroupViewController

@synthesize jsonArray, tableViewList;
@synthesize searchGroupBtn, messageGroupBtn;

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
    
    // display items
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    UILabel *groupNameLabel = (UILabel *)[cell viewWithTag:100];
    
    [groupNameLabel setText:[item objectForKey:@"groupName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
	MTBGroupDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBGroupDetailViewController"];
    [viewController setGroupName:[item objectForKey:@"groupName"]];
    [viewController setGroupID:[[item objectForKey:@"groupID"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"My groups";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
    
    [self downloadContent];
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditGroups,EDIT",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              jsonArray = [NSMutableArray arrayWithCapacity:0];
              [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
              
              [tableViewList reloadData];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (IBAction)pressSearchGropupBtn:(id)sender {
    
}

- (IBAction)pressMessageGroupBtn:(id)sender {
    MTBGroupMessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBGroupMessageViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

//
//  MTBSearchBioViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/3/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBSearchBioViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#import "MTBProfileViewController.h"

@interface MTBSearchBioViewController ()

@end

@implementation MTBSearchBioViewController

@synthesize searchType, searchTerm, jsonArray, tableViewList;

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
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SearchBioViewController";
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)] style: UIBarButtonItemStylePlain target:nil action:nil];
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
    return [jsonArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // display items
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    NSString *userProfileImage = [[item objectForKey:@"Profile"] stringByReplacingOccurrencesOfString:@".." withString:@""];
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // user name
    userNameLabel.text = [item objectForKey:@"listMbrName"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
    MTBProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfileViewController"];
	[viewController setMemID:[[item objectForKey:@"listMbrID"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Results"];
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"Search,%@", searchType],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"SearchChars"     :searchTerm};
    
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

@end

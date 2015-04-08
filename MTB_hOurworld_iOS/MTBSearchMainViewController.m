//
//  MTBSearchMainViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBSearchMainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "MTBSearchProRcvViewController.h"
#import "MTBSearchBioViewController.h"

@interface MTBSearchMainViewController ()

@end

@implementation MTBSearchMainViewController
@synthesize jsonArray, outputArray, tableViewList, searchBar, searchBtn;

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
    
    // rounded corner
    searchBtn.layer.cornerRadius = 5;
    searchBtn.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SearchMainViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)pressSearchBtn:(id)sender {
    
//searchTerm = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    searchTerm = searchBar.text;
    
    NSLog(@"%@", searchTerm);
    
    if (![searchTerm isEqual:(id)[NSNull null]]
        && [searchTerm length] == 0
        && ![searchTerm isEqualToString:@""]) {
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Please_enter_a_search_term", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
        [dialog show];
    }
    else {
        // retrieve information from the selected search term
        [self downloadContent];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"length: %lu", (unsigned long)[outputArray count]);
    
    return [outputArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // display items
    NSDictionary *item = [outputArray objectAtIndex:indexPath.row];    
    UIImageView *requestIcon = (UIImageView *)[cell viewWithTag:100];
    UILabel *requestType = (UILabel *)[cell viewWithTag:101];
    
    NSString *icon = [item objectForKey:@"icon"];
    icon = [icon stringByReplacingOccurrencesOfString:@".." withString:@""];
    
    //[requestIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", icon]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [requestIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", icon]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    requestIcon.layer.cornerRadius = requestIcon.frame.size.width / 2;
    requestIcon.clipsToBounds = YES;
    requestIcon.layer.borderWidth = 1.0f;
    requestIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    NSString *requestModName = @"";
    
    if ([[item objectForKey:@"requestMod"] isEqualToString:@"Pro"]) {
        requestModName = @"Offers";
    }
    else if ([[item objectForKey:@"requestMod"] isEqualToString:@"Rcv"]) {
        requestModName = @"Requests";
    }
    else if ([[item objectForKey:@"requestMod"] isEqualToString:@"Bio"]) {
        requestModName = @"Profiles";
    }
    else {
        requestModName = [item objectForKey:@"requestMod"];
    }
    
    [requestType setText:[NSString stringWithFormat:@"%@ (%d)", requestModName, [[item objectForKey:@"Members"] intValue]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [outputArray objectAtIndex:indexPath.row];
    
    NSString *requestMode = [item objectForKey:@"requestMod"];
    
    // this is a tentative change. Stephen needs to update the call.
    if ([requestMode isEqualToString:@"Pro"]) {
        MTBSearchProRcvViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBSearchProRcvViewController"];
        [viewController setSearchTerm:searchTerm];
        [viewController setSearchType:@"Pro"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([requestMode isEqualToString:@"Rcv"]) {
        MTBSearchProRcvViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBSearchProRcvViewController"];
        [viewController setSearchTerm:searchTerm];
        [viewController setSearchType:@"Rcv"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([requestMode isEqualToString:@"Bio"]) {
        MTBSearchBioViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBSearchBioViewController"];
        [viewController setSearchTerm:searchTerm];
        [viewController setSearchType:@"Bio"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([requestMode isEqualToString:@"Name"]) {
        MTBSearchBioViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBSearchBioViewController"];
        [viewController setSearchTerm:searchTerm];
        [viewController setSearchType:@"Name"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([requestMode isEqualToString:@"Msg"]) {
    }
    else if ([requestMode isEqualToString:@"KB"]) {
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Search", nil)];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)] style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"Search,All",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"SearchChars"     :[NSString stringWithFormat:@"%@", searchTerm]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if ([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
                  if (![[responseObject objectForKey:@"results"]isEqual:[NSNull null]]) {
                      
                      jsonArray = [NSMutableArray arrayWithCapacity:0];
                      [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                      
                      outputArray = [NSMutableArray arrayWithCapacity:0];
                      
                      
                      for (int i = 0 ; i < [jsonArray count]; i++) {
                          NSDictionary *item = [jsonArray objectAtIndex:i];
                          
                          // we dont care Msg or KB at the moment
                          if ([[item objectForKey:@"requestMod"]isEqual:@"KB"] ||
                              [[item objectForKey:@"requestMod"]isEqual:@"Msg"]) {
                              continue;
                          }
                          else {
                              [outputArray addObject:item];
                          }
                      }
                      
                      if ([jsonArray count] != 0) {
                          [tableViewList reloadData];
                      }
                      else {
                          // do nothing
                          UIAlertView *dialog = [[UIAlertView alloc]init];
                          [dialog setDelegate:nil];
                          [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                          [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
                          [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
                          [dialog show];
                      }
                  }
                  else {
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                      [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
                      [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
                      [dialog show];
                  }
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:nil];
                  [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                  [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
                  [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
                  [dialog show];
              }

              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
              
              UIAlertView *dialog = [[UIAlertView alloc]init];
              [dialog setDelegate:nil];
              [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
              [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
              [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
              [dialog show];
          }];
}

// when the enter button clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    searchTerm = searchBar.text;
    
    NSLog(@"%@", searchTerm);
    
    if (![searchTerm isEqual:(id)[NSNull null]]
        && [searchTerm length] == 0
        && ![searchTerm isEqualToString:@""]) {
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Please_enter_a_search_term", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
        [dialog show];
    }
    else {
        
        [tableViewList clearsContextBeforeDrawing];
        
        // retrieve information from the selected search term
        [self downloadContent];
    }
    
    [textField resignFirstResponder];
    return NO;
}

@end
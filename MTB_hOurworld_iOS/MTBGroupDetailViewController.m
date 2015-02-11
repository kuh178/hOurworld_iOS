//
//  MTBGroupDetailViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBGroupDetailViewController.h"
#import "MTBAddGroupMessageViewController.h"
#import "MTBProfileViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBGroupDetailViewController ()

@end

@implementation MTBGroupDetailViewController
@synthesize groupName, groupDescription, groupID;
@synthesize jsonArray, tableViewList, leaveGroupBtn, joinGroupBtn, groupNameLabel, groupMembersNumLabel;

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
    
    isMember = false;
    
    [groupNameLabel setText:groupName];
    [self downloadContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Group details";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
    
    [self downloadContent];
}

-(IBAction)leaveGroupBtnClicked:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Leave this group?"
                                                     delegate:self
                                            cancelButtonTitle:@"Leave"
                                            otherButtonTitles:@"Cancel", nil];
    [message show];
}

-(IBAction)joinGroupBtnClicked:(id)sender {
    
    if (isMember) {
        MTBAddGroupMessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBAddGroupMessageViewController"];
        [viewController setGroupID:groupID];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"Join this group?"
                                                         delegate:self
                                                cancelButtonTitle:@"Join"
                                                otherButtonTitles:@"Cancel", nil];
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Join"]) {
        [self groupJoin];
    }
    else if([title isEqualToString:@"Leave"]) {
        [self groupLeave];
    }
}

- (void) groupJoin {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditGroups,ADD",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"groupID"         :[NSString stringWithFormat:@"%ld", (long)groupID]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([[responseObject objectForKey:@"success"] boolValue]) {
                  [self.navigationController popViewControllerAnimated:YES];
              }
            
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (void) groupLeave {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditGroups,DEL",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"groupID"         :[NSString stringWithFormat:@"%ld", (long)groupID]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([[responseObject objectForKey:@"success"] boolValue]) {
                  [self.navigationController popViewControllerAnimated:YES];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (void) downloadContent {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditGroups,MBRS",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"groupID"         :[NSString stringWithFormat:@"%ld", (long)groupID]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if(![[responseObject objectForKey:@"results"]isEqual:[NSNull null]] && ![[responseObject objectForKey:@"results"]isEqual:@"{}"]) {
                  jsonArray = [NSMutableArray arrayWithCapacity:0];
                  [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                  
                  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                  
                  [groupMembersNumLabel setText:[NSString stringWithFormat:@"Group members (%lu)", (unsigned long)[jsonArray count]]];
                  
                  // check if I am a member of this group
                  for (int i = 0 ; i < [jsonArray count]; i++) {
                      NSDictionary *item = [jsonArray objectAtIndex:i];
                      if([[item objectForKey:@"grpMbrID"] intValue] == [[userDefault objectForKey:@"memID"] intValue]) {
                          isMember = true;
                      }
                  }
                  
                  if(isMember) {
                      // change the button text from "Join this group" to "Send a message"
                      joinGroupBtn.title = @"Send a message";
                      [leaveGroupBtn setEnabled:YES];
                  }
                  else {
                      // nothing happens
                      [leaveGroupBtn setEnabled:NO];
                  }
                  
                  [tableViewList reloadData];
              }
              else {
                  // no group member
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
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
    
    NSString *userProfileImage = [item objectForKey:@"grpMbrImg"];
    userProfileImage = [userProfileImage stringByReplacingOccurrencesOfString:@".." withString:@""];
    
    // user image
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]]  placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;

    [userNameLabel setText:[item objectForKey:@"grpMbrName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *item = [jsonArray objectAtIndex:indexPath.row];
    
	MTBProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfileViewController"];
	[viewController setMemID:[[item objectForKey:@"grpMbrID"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end

//
//  MTBSearchProRcvViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/3/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBSearchProRcvViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MTBTaskDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#import "MTBProfileViewController.h"

@interface MTBSearchProRcvViewController ()

@end

@implementation MTBSearchProRcvViewController

@synthesize searchType, searchTerm, jsonArray, scheduleList, tableViewList;

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
    
    NSLog(@"searchTerm : %@", searchTerm);
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SearchOfferRequestViewController";
    
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
    return [scheduleList count];
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
    MTBItem *item = [scheduleList objectAtIndex:indexPath.row];
    
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:102];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    NSString *userProfileImage = [item.mProfileImage stringByReplacingOccurrencesOfString:@".." withString:@""];
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", userProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // user name
    userNameLabel.text = item.mUserName;

    // description
    [descriptionLabel setText:item.mDescription];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
    MTBItem *item = [scheduleList objectAtIndex:indexPath.row];
    NSString *text = item.mDescription;
    
    if ([text isEqual:[NSNull null]]) {
        text = @"";
    }
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
	CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    int height = 0;
    
    if(text.length < 50) {
        height = 50;
    }
    else if(text.length >= 50 && text.length < 100) {
        height = 35;
    }
    else if(text.length > 500){
        height = -100;
    }
    else {
        height = 0;
    }
    
	return labelSize.height + height;
     */
    
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // move to the detailed view
    MTBTaskDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBTaskDetailViewController"];
        [viewController setMItem:[scheduleList objectAtIndex:indexPath.row]];
    
    if ([searchType isEqualToString:@"Pro"]) {
        [viewController setMIsOffer:@"T"];
    }
    else if ([searchType isEqualToString:@"Rcv"]) {
        [viewController setMIsOffer:@"F"];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *titleText = @"";
    // update the name
    if ([searchType isEqualToString:@"Pro"]) {
        titleText = @"Offers";
    }
    else if ([searchType isEqualToString:@"Rcv"]) {
        titleText = @"Requests";
    }
    else {
        titleText = searchType;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:[NSString stringWithFormat:@"%@", titleText]];
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
              scheduleList = [NSMutableArray arrayWithCapacity:0];
              
              [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
              
              int i;
              int arrayCount = [jsonArray count];
              
              if(arrayCount > 0) {
                  // insert new items into the table
                  for (i = 0 ; i < arrayCount; i++) {
                      // get an item
                      NSDictionary *item = [jsonArray objectAtIndex:i];
                      NSDictionary *locObj = [item objectForKey:@"mobLatLon"];
                      
                      // xDays is not used in Offers and Requests yet, but probably will be...
                      // check if xDays has null; if so, assign a default (14 days)
                      int xDays = 14;
                      
                      if ([[locObj objectForKey:@"xDays"] isEqual:[NSNull null]]) {
                          xDays = 14;
                      }
                      else {
                          xDays = [[locObj objectForKey:@"xDays"] intValue];
                      }
                      
                      MTBItem *tItem;
                      
                      if([locObj objectForKey:@"oLat"] != (id)[NSNull null] && [[locObj objectForKey:@"oLat"] length] > 5) {
                          tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"SvcDescr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName: [item objectForKey:@"listMbrName"] ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:[[locObj objectForKey:@"oLat"] doubleValue] EOLon:[[locObj objectForKey:@"oLon"] doubleValue] EDLat:[[locObj objectForKey:@"dLat"] doubleValue] EDLon:[[locObj objectForKey:@"dLon"] doubleValue] EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                      }
                      else {
                          tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"SvcDescr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName:[item objectForKey:@"listMbrName"] ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:0.0 EOLon:0.0 EDLat:0.0 EDLon:0.0 EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                      }
                      
                      [scheduleList addObject:tItem];
                  }
              }
              else {
                  NSLog(@"No data available");
              }
              
              if ([scheduleList count] != 0) {
                  
                  [tableViewList reloadData];
              }
              else {
                  // do nothing
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                  [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"No_result", nil)]];
                  [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"OK", nil)]];
                  [dialog show];
              }
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end

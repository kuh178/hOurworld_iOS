//
//  MTBTaskCategoryServiceTaskViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/17/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBTaskCategoryServiceTaskViewController.h"
#import "ImageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBItem.h"
#import "MTBTaskDetailViewController.h"
#import "MTBCategoryViewController.h"
#import "MTBProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MTBFinalTaskPostViewController.h"

@interface MTBTaskCategoryServiceTaskViewController ()

@end

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 15.0f

@implementation MTBTaskCategoryServiceTaskViewController

@synthesize scheduleList;
@synthesize scheduleListCopy;
@synthesize jsonArray;
@synthesize tableViewList;
@synthesize svcCat;
@synthesize svcCatID;
@synthesize service;
@synthesize svcID;
@synthesize isOffer;
@synthesize isRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    NSLog(@"%@", isOffer);
    NSLog(@"%@", isRequest);
    
    if ([isOffer isEqualToString:@"T"]) {
        self.title = @"Offers";
    }
    else {
        self.title = @"Requests";
    }
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MTBTaskCategoryServiceTaskViewController";
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
    MTBItem *tItem = [scheduleList objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *datetimeLabel = (UILabel *)[cell viewWithTag:103];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", tItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", tItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // user name
    if (tItem.mUserName != (id)[NSNull null] && [tItem.mUserName length] != 0) {
        userNameLabel.text = tItem.mUserName;
    }
    else {
        userNameLabel.text = @"No username found";
    }
    
    // description
    if (tItem.mDescription != (id)[NSNull null] && [tItem.mDescription length] != 0) {
        [descriptionLabel setText:tItem.mDescription];
    }
    else {
        [descriptionLabel setText:@"No description found"];
    }
    
    
    // timestamp
    if (tItem.mTimestamp != (id)[NSNull null]) {
        NSArray *splitTimestamp = [tItem.mTimestamp componentsSeparatedByString:@" "];
        datetimeLabel.text = splitTimestamp[0];
    }
    else {
        datetimeLabel.text = @"No datetime found";
    }
    
    // user image clicked
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [cell.imageView addGestureRecognizer:tapGesture];
    cell.imageView.userInteractionEnabled = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBTaskDetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableViewList indexPathForCell:sender];
        MTBItem *mItem = [scheduleList objectAtIndex:indexPath.row];
        
        MTBTaskDetailViewController *viewController = (MTBTaskDetailViewController *)[segue destinationViewController];
        [viewController setMItem:mItem];
        [viewController setMIsOffer:isOffer];
    }
    else if([[segue identifier] isEqualToString: @"MTBFinalTaskPostViewController"]) {
        MTBFinalTaskPostViewController *viewController = (MTBFinalTaskPostViewController *)[segue destinationViewController];
        [viewController setSvcCat:svcCat];
        [viewController setSvcCatID:svcCatID];
        [viewController setService:service];
        [viewController setSvcID:svcID];
        [viewController setIsOffer:isOffer];
        [viewController setIsRequest:isRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    // automatically reload only if there is some insertion or deletion
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"reload"] intValue] == 1) {
        
        // update to '0'
        [userDefault setInteger:0 forKey:@"reload"];
        
        [self downloadContent];
    }
    else {
        
    }
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params;
    
    if ([isOffer isEqualToString:@"T"]) {
        params = @{@"requestType"     :[NSString stringWithFormat:@"OfferSvc,%ld:%ld", (long)svcCatID, (long)svcID],
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"]};
    }
    else {
        params = @{@"requestType"     :[NSString stringWithFormat:@"RequestSvc,%ld:%ld", (long)svcCatID, (long)svcID],
                   @"accessToken"     :[userDefault objectForKey:@"access_token"],
                   @"EID"             :[userDefault objectForKey:@"EID"],
                   @"memID"           :[userDefault objectForKey:@"memID"]};
    }
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if ([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
                  jsonArray           = [NSMutableArray arrayWithCapacity:0];
                  scheduleList        = [NSMutableArray arrayWithCapacity:0];
                  scheduleListCopy    = [NSMutableArray arrayWithCapacity:0];
                  categoryList        = [NSMutableArray arrayWithCapacity:0];
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
                          
                          NSString *memName = [NSString stringWithFormat:@"%@ %@", [item objectForKey:@"Fname"], [item objectForKey:@"Lname"]];
                          
                          if([locObj objectForKey:@"oLat"] != (id)[NSNull null] && [[locObj objectForKey:@"oLat"] intValue] != 0) {
                              
                              tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"Descr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName: memName ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:[[locObj objectForKey:@"oLat"] doubleValue] EOLon:[[locObj objectForKey:@"oLon"] doubleValue] EDLat:[[locObj objectForKey:@"dLat"] doubleValue] EDLon:[[locObj objectForKey:@"dLon"] doubleValue] EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                          }
                          else {
                              tItem = [[MTBItem alloc] initToTask:[[item objectForKey:@"listMbrID"] intValue] Edescr:[item objectForKey:@"Descr"] ESvcCat:[item objectForKey:@"SvcCat"] EMemName:memName ESvcCatID:[[item objectForKey:@"SvcCatID"] intValue] ESvcID:[[item objectForKey:@"SvcID"] intValue] EService:[item objectForKey:@"Service"] ETimestamp:[item objectForKey:@"timestamp"] EProlfileImage:[item objectForKey:@"Profile"] EOLat:0.0 EOLon:0.0 EDLat:0.0 EDLon:0.0 EXDays:xDays EEmail1:[item objectForKey:@"Email1"]];
                          }
                          
                          [scheduleList addObject:tItem];
                          [scheduleListCopy addObject:tItem];
                          [categoryList addObject:[item objectForKey:@"SvcCat"]];
                      }
                  }
                  else {
                      NSLog(@"No data available");
                  }
                  
                  // remove duplicates in the categoryList
                  NSArray *copy = [categoryList copy];
                  NSInteger index = [copy count] - 1;
                  for (id object in [copy reverseObjectEnumerator]) {
                      if ([categoryList indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
                          [categoryList removeObjectAtIndex:index];
                      }
                      index--;
                  }
                  
                  // sort the categoryList : http://stackoverflow.com/questions/805547/how-to-sort-an-nsmutablearray-with-custom-objects-in-it
                  NSArray *sortedArray;
                  sortedArray = [categoryList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                      return [a compare:b];
                  }];
                  [categoryList removeAllObjects];
                  
                  [categoryList addObject:@"All"];
                  [categoryList addObject:@"My Offers"];
                  [categoryList addObjectsFromArray:sortedArray];
                  //categoryList = [NSMutableArray arrayWithArray:sortedArray];
                  
                  [tableViewList reloadData];
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"No search result"];
                  [dialog addButtonWithTitle:@"OK"];
                  [dialog show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

@end
//
//  FirstViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "FirstViewController.h"
#import "MTBLoginViewController.h"
#import "ImageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBItem.h"
#import "MTBMessageDetailViewController.h"
#import "MTBAddMessageViewController.h"
#import "MTBProfileViewController.h"
#import "MTBLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize scheduleList;
@synthesize jsonArray;
@synthesize tableViewList;
@synthesize refreshBtn;
@synthesize addBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MessageViewController";
    
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
    UIImageView *xDayLabel = (UIImageView *)[cell viewWithTag:104];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", tItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.layer.borderWidth = 1.0f;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;

    // user name
    if (tItem.mListMbrName != (id)[NSNull null] && [tItem.mListMbrName length] != 0) {
        userNameLabel.text = tItem.mListMbrName;
    }
    else{
       userNameLabel.text = @"No username found";
    }
    
    // description
    if (tItem.mEblast != (id)[NSNull null] && [tItem.mEblast length] != 0) {
        
        [descriptionLabel setText:[self stringByStrippingHTML:tItem.mEblast]];
    }
    else {
        [descriptionLabel setText:@"No messages found"];
    }
    
    // timestamp
    if (tItem.mTimestamp != (id)[NSNull null]) {
        NSArray *splitTimestamp = [tItem.mTimestamp componentsSeparatedByString:@" "];
        datetimeLabel.text = splitTimestamp[0];
    }
    else {
        datetimeLabel.text = @"No datetime found";
    }
    
    // xDay
    if (tItem.xDays > 7) {
        [xDayLabel setHidden:YES];
    }
    else if (tItem.xDays > 3 && tItem.xDays <= 7) {
        [xDayLabel setHidden:NO];
        UIImage *image = [UIImage imageNamed: @"in_a_week.png"];
        [xDayLabel setImage:image];
    }
    else if (tItem.xDays > 1 && tItem.xDays <= 3) {
        [xDayLabel setHidden:NO];
        UIImage *image = [UIImage imageNamed: @"in_three_days.png"];
        [xDayLabel setImage:image];
    }
    else if (tItem.xDays > 0 && tItem.xDays <= 1) {
        [xDayLabel setHidden:NO];
        UIImage *image = [UIImage imageNamed: @"in_a_day.png"];
        [xDayLabel setImage:image];
    }

    // user image clicked
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [cell.imageView addGestureRecognizer:tapGesture];
    cell.imageView.userInteractionEnabled = YES;
    
    return cell;
}

// Remove some of HTML tags
-(NSString *) stringByStrippingHTML:(NSString *)inputStr {
    NSRange r;

    while ((r = [inputStr rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        inputStr = [inputStr stringByReplacingCharactersInRange:r withString:@""];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    inputStr = [inputStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n\n"];
    
    return inputStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Fix the height to 90.
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBMessageDetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableViewList indexPathForCell:sender];
        MTBItem *mItem = [scheduleList objectAtIndex:indexPath.row];
        
        MTBMessageDetailViewController *viewController = (MTBMessageDetailViewController *)[segue destinationViewController];
        [viewController setMItem:mItem];
    }
}

- (IBAction)pressRefreshBtn:(id)sender {
    [self downloadContent];
}

- (IBAction)pressAddBtn:(id)sender {
    MTBAddMessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBAddMessageViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.title = @"Announcements";
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    // start downloading
    // show a dialogbox asking download JSON strings
    // http://stackoverflow.com/questions/4269842/objective-c-server-requests-in-a-thread-like-asynctask-in-android
    // http://allseeing-i.com/ASIHTTPRequest/Setup-instructions
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"Messages,0",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
                    //Upload Progress bar here
                    NSLog(@"progress updated(percentDone) : %f", percentDone);
                }];
                
                NSLog(@"responseObject : %@", responseObject);
                
                // check the return value of "success"
                if ([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
                    jsonArray = [NSMutableArray arrayWithCapacity:0];
                    scheduleList = [NSMutableArray arrayWithCapacity:0];
                    [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                  
                    int i;
                    long arrayCount = [jsonArray count];
                    
                    bool hasItem = false;
                  
                    if(arrayCount > 0) {
                        // insert new items into the table
                        for (i = 0 ; i < arrayCount; i++) {
                            // get an item
                            NSDictionary *item = [jsonArray objectAtIndex:i];
                            
                            // if the description contains "No messages found." continue
                            if ([[item objectForKey:@"Eblast"] isEqual:@"No messages found."]) {
                                continue;
                            }
                            
                            NSDictionary *locObj = [item objectForKey:@"mobLatLon"];
                          
                            if ([[item objectForKey:@"Eblast"] isEqualToString:@""]) {
                                continue;
                            }
                          
                            int xDays = 14;
                          
                            if ([[locObj objectForKey:@"xDays"] isEqual:[NSNull null]]) {
                                xDays = 14;
                            }
                            else {
                                xDays = [[locObj objectForKey:@"xDays"] intValue];
                            }
                          
                            MTBItem *tItem;
                          
                            if([locObj objectForKey:@"oLat"] != (id)[NSNull null] && [[locObj objectForKey:@"oLat"] intValue] != 0) {
                                tItem = [[MTBItem alloc] initToMessage:[item objectForKey:@"Exp"] Eblast:[item objectForKey:@"Eblast"] ListMbrID:[[item objectForKey:@"listMbrID"] intValue] PostNum:[[item objectForKey:@"PostNum"] intValue] ProfileImage:[item objectForKey:@"Profile"] TimeStamp:[item objectForKey:@"timestamp"] Email:[item objectForKey:@"Email1"] Phone:[item objectForKey:@"Phone"] ListMbrName:[item objectForKey:@"Name"] EOLat:[[locObj objectForKey:@"oLat"] doubleValue]  EOLon:[[locObj objectForKey:@"oLon"] doubleValue] EDLat:[[locObj objectForKey:@"dLat"] doubleValue] EDLon:[[locObj objectForKey:@"dLon"] doubleValue] EXDays:xDays];
                            }
                            else {
                                tItem = [[MTBItem alloc] initToMessage:[item objectForKey:@"Exp"] Eblast:[item objectForKey:@"Eblast"] ListMbrID:[[item objectForKey:@"listMbrID"] intValue] PostNum:[[item objectForKey:@"PostNum"] intValue] ProfileImage:[item objectForKey:@"Profile"] TimeStamp:[item objectForKey:@"timestamp"] Email:[item objectForKey:@"Email1"] Phone:[item objectForKey:@"Phone"] ListMbrName:[item objectForKey:@"Name"] EOLat:0.0 EOLon:0.0 EDLat:0.0 EDLon:0.0    EXDays:xDays];
                            }
                          
                            
                            hasItem = true;
                            [scheduleList addObject:tItem];
                        }
                    }
                    else {
                        NSLog(@"No data available");
                    }
                    
                    if (hasItem == false) {
                        UIAlertView *dialog = [[UIAlertView alloc]init];
                        [dialog setDelegate:nil];
                        [dialog setTitle:@"Message"];
                        [dialog setMessage:@"No result."];
                        [dialog addButtonWithTitle:@"OK"];
                        [dialog show];
                    }
                    
                    [tableViewList reloadData];
                }
                else {
                    UIAlertView *dialog = [[UIAlertView alloc]init];
                    [dialog setDelegate:self];
                    [dialog setTitle:@"Message"];
                    [dialog setMessage:@"No result. (If you see this message multiple times, try logout and re-login)"];
                    [dialog addButtonWithTitle:@"OK"];
                    [dialog show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", operation);
            }];
}

@end

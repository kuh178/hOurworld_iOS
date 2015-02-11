//
//  MTBProfileStatementViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 2/4/15.
//  Copyright (c) 2015 HCI PSU. All rights reserved.
//

#import "MTBProfileStatementViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"

@interface MTBProfileStatementViewController ()

@end

@implementation MTBProfileStatementViewController

@synthesize statementArray, tableViewList;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MTBProfileStatement";
    
   [self downloadContent];
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
    
    NSLog(@"statement count: %lu", (unsigned long)[statementArray count]);
    
    return [statementArray count];
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
    NSMutableDictionary *item = [statementArray objectAtIndex:indexPath.row];
    UILabel *providerName   = (UILabel *)[cell viewWithTag:100];
    UILabel *receiverName   = (UILabel *)[cell viewWithTag:101];
    UILabel *category       = (UILabel *)[cell viewWithTag:102];
    UILabel *reportedDate   = (UILabel *)[cell viewWithTag:103];
    UILabel *reportedHour   = (UILabel *)[cell viewWithTag:104];
    
    [providerName setText:[item objectForKey:@"ProName"]];
    [receiverName setText:[item objectForKey:@"RcvName"]];
    [category setText:[item objectForKey:@"Service"]];
    [reportedDate setText:[item objectForKey:@"transDate"]];
    [reportedHour setText:[item objectForKey:@"TDs"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Fix the height to 135
    return 135.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.title = @"Statement";
    [super viewWillAppear:animated];
}

- (void) downloadContent {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"Statement,365",
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
        statementArray = [NSMutableArray arrayWithCapacity:0];
        [statementArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
        
        if ([statementArray count] == 0) {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No result"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
        [tableViewList reloadData];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"No result"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", operation);
}];
}

@end

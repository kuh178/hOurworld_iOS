//
//  MTBOffersRequestsViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 4/24/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBOffersRequestsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBItem.h"
#import "MTBReportHoursViewController.h"

@interface MTBOffersRequestsViewController ()

@end

@implementation MTBOffersRequestsViewController

@synthesize list;
@synthesize tableViewList;

int selectedIndex = 0;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"OffersRequestsFromBioViewController";
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
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
    return [list count];
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
    NSMutableDictionary *tItem = [list objectAtIndex:indexPath.row];
    UIImageView *userImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *serviceCatLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *refCountLabel = (UILabel *)[cell viewWithTag:103];
    
    // user image
    // reference: https://github.com/rs/SDWebImage
    //[userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", [tItem objectForKey:@"SvcImage"]]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", [tItem objectForKey:@"SvcImage"]]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    
    // Service Cat
    if ([tItem objectForKey:@"SvcCat"] != (id)[NSNull null] && [[tItem objectForKey:@"SvcCat"] length] != 0) {
        [serviceCatLabel setText:[NSString stringWithFormat:@"%@", [tItem objectForKey:@"SvcCat"]]];
    }
    else {
        [serviceCatLabel setText:@""];
    }
    
    // description
    if ([tItem objectForKey:@"SvcDescr"] != (id)[NSNull null] && [[tItem objectForKey:@"SvcDescr"] length] != 0) {
        [descriptionLabel setText:[NSString stringWithFormat:@"%@", [tItem objectForKey:@"SvcDescr"]]];
    }
    else {
        [descriptionLabel setText:@"No description found"];
    }
    
    // number of refs
    if ([[tItem objectForKey:@"refCountLabel"] intValue] <= 1) {
        refCountLabel.text = [NSString stringWithFormat:@"%d ref", [[tItem objectForKey:@"refCountLabel"] intValue]];
    }
    else {
        refCountLabel.text = [NSString stringWithFormat:@"%d refs", [[tItem objectForKey:@"refCountLabel"] intValue]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath.row;
    
    // move to report hour page
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Did you provide or receive this service?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Provided", @"Received", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    NSMutableDictionary *item = [list objectAtIndex:selectedIndex];
    
    // this are hard-coded values
    MTBItem *mItem  = [[MTBItem alloc]init];
    mItem.mSvcCatID = [[item objectForKey:@"SvcCatID"] intValue];;
    mItem.mSvcID    = [[item objectForKey:@"SvcID"] intValue];
    
    if([title isEqualToString:@"Provided"])
    {
        NSLog(@"Provided");
        MTBReportHoursViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHoursViewController"];
        [viewController setIsProvider:@"T"];
        [viewController setIsReceiver:@"F"];
        [viewController setMItem:mItem];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([title isEqualToString:@"Received"])
    {
        NSLog(@"Received");
        MTBReportHoursViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHoursViewController"];
        [viewController setIsProvider:@"F"];
        [viewController setIsReceiver:@"T"];
        [viewController setMItem:mItem];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

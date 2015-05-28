//
//  MTBTaskDetailViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBTaskDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "QuartzCore/QuartzCore.h"
#import "MTBProfileViewController.h"
#import "MTBReportHoursViewController.h"
#import "LargeMapViewController.h"
#import "MTBTaskEditViewController.h"
#import "MTBProfilePrivateEmailViewController.h"

@interface MTBTaskDetailViewController ()

@end

@implementation MTBTaskDetailViewController

@synthesize mItem;
@synthesize taskInfoTextView, profileImage, mapView, locationLabel, usernameBtn, timestampLabel, taskCategoryLabel, scrollView, largeMapViewBtn;
@synthesize reportHoursBtn, removeBtn, replyBtn, editBtn, mIsOffer;
@synthesize webView;

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
    
    [self showViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"TaskDetailViewController";
}


- (void) showViews {
    
    // display "remove" btn
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (mItem.mListMbrID == 0) {
        [reportHoursBtn setEnabled:NO];
    }
    else {
        [reportHoursBtn setEnabled:YES];
    }
    
    if([[userDefault objectForKey:@"memID"] intValue] == mItem.mListMbrID) {
        [removeBtn setEnabled:YES];
        [editBtn setEnabled:YES];
    }
    else {
        [removeBtn setEnabled:NO];
        [editBtn setEnabled:NO];
    }
    
    // handling username
    if (mItem.mUserName != (id)[NSNull null] && [mItem.mUserName length] != 0) {
        [usernameBtn setTitle:mItem.mUserName forState:UIControlStateNormal];
    }
    else {
        [usernameBtn setTitle:@"Not available" forState:UIControlStateNormal];
    }
    
    // handling timestamp
    if (mItem.mTimestamp != (id)[NSNull null]) {
        NSArray* timestampSplit = [mItem.mTimestamp componentsSeparatedByString: @" "];
        NSString* timestamp = [timestampSplit objectAtIndex: 0];
        timestampLabel.text = [NSString stringWithFormat:@"Posted: %@", timestamp];
    }
    else {
        timestampLabel.text = @"No datetime";
    }
    
    if (mItem.mSvcCat != (id)[NSNull null]) {
        taskCategoryLabel.text = [NSString stringWithFormat:@"%@ > %@", mItem.mSvcCat, mItem.mService];
    }

    // handling eBlast
    taskInfoTextView.frame = [self calculateSize2:mItem.mDescription TextView:taskInfoTextView];
    if (mItem.mDescription != (id)[NSNull null] && [mItem.mDescription length] != 0) {
        taskInfoTextView.text = mItem.mDescription;
    }
    else {
        taskInfoTextView.text = @"No description found";
    }
    
    scrollView.contentSize = CGSizeMake(320, taskInfoTextView.frame.size.height + 100);
    
    // handling user profile image
    //[profileImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", mItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    [profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", mItem.mProfileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
    
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
    profileImage.clipsToBounds = YES;
    profileImage.layer.borderWidth = 1.0f;
    profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // handling user profile image tapping activity
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [profileImage addGestureRecognizer:tapGesture];
    profileImage.userInteractionEnabled = YES;

    // handling a map
    if (mItem.mDLat == 0.0 || mItem.mDLon == 0.0) { // if there is no location information, hide the mapview
        [mapView setHidden:NO];
        [locationLabel setHidden:YES];
        [largeMapViewBtn setHidden:YES];
        
        scrollView.contentSize = CGSizeMake(320, taskInfoTextView.frame.size.height + 150);
    }
    else { // add a pushpin in the map.
        [mapView setHidden:NO];
        [locationLabel setHidden:NO];
        [largeMapViewBtn setHidden:NO];
        
        mapView.delegate = self;
        CLLocationCoordinate2D location;
        location.latitude = mItem.mDLat;
        location.longitude = mItem.mDLon;

        LocationAnnotation *locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:location];
        [mapView addAnnotation:locationAnnotation];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
        
        [mapView setRegion:region animated:FALSE];
        [mapView regionThatFits:region];
        
        scrollView.contentSize = CGSizeMake(320, taskInfoTextView.frame.size.height + locationLabel.frame.size.height + mapView.frame.size.height + 230);
    }
    
    [[mapView layer] setMasksToBounds:NO];
    [[mapView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[mapView layer] setShadowOpacity:1.0f];
    [[mapView layer] setShadowRadius:1.0f];
    [[mapView layer] setShadowOffset:CGSizeMake(0, 1)];
}

- (void)showPan
{
    NSLog(@"panning!");
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (CGRect) calculateSize:(NSString *)pInput Label:(UILabel *)pLabel {
    CGSize expectedLabelSize = [pInput sizeWithAttributes:@{NSFontAttributeName:pLabel.font}];
    
    //adjust the label the the new height.
    CGRect newFrame = pLabel.frame;
    newFrame.size.height = expectedLabelSize.height + 20;
    
    return newFrame;
}

- (CGRect) calculateSize2:(NSString *)pInput TextView:(UITextView *)pTextView {
    CGSize expectedTextViewSize = [pInput sizeWithAttributes:@{NSFontAttributeName:pTextView.font}];
    
    //adjust the label the the new height.
    CGRect newFrame = pTextView.frame;
    newFrame.size.height = expectedTextViewSize.height + 300;
    
    return newFrame;
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"%ld", (long)mItem.mListMbrID);
    
    if(mItem.mListMbrID == 0) {
        // do nothing
    }
    else {
        MTBProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfileViewController"];
        [viewController setMemID:mItem.mListMbrID];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(IBAction)pressReportHourBtn:(id)sender {
    // move to a report hour page
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Did you provide or receive this service?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Provided", @"Received", nil];
    [message show];
    
}

-(IBAction)pressRemoveBtn:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Remove this task?"
                                                     delegate:self
                                            cancelButtonTitle:@"Remove"
                                            otherButtonTitles:@"Cancel", nil];
    [message show];

}

-(IBAction)pressLargeMapViewBtn:(id)sender {
    LargeMapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LargeMapViewController"];
    [viewController setLatitude:mItem.mDLat];
    [viewController setLongitude:mItem.mDLon];
    [self.navigationController pushViewController:viewController animated:YES];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
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
    else if([title isEqualToString:@"Remove"])
    {
        [self removeTask];
    }
    else {
        // "Cancel"
    }
}

- (void)removeTask {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"DelTask,%ld:%ld", (long)mItem.mSvcCatID, (long)mItem.mSvcID],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([responseObject objectForKey:@"success"]) {
                  
                  NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                  [userDefault setInteger:1 forKey:@"reload"];
                  [self.navigationController popViewControllerAnimated:YES];
                  
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"Failed to remove your task. Please try again"];
                  [dialog addButtonWithTitle:@"Close"];
                  [dialog show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([mIsOffer isEqualToString:@"T"]) {
        self.title = @"Offer Details";
        //[[self navigationItem] setTitle:@"Offer Details"];
    }
    else {
        self.title = @"Request Details";
        //[[self navigationItem] setTitle:@"Request Details"];
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

-(IBAction)pressReplyBtn:(id)sender {
    
    /*
    NSString *emailTitle;
    
    if ([mIsOffer isEqualToString:@"T"]) {
        emailTitle = [NSString stringWithFormat:@"Response to your offer"];
    }
    else {
        emailTitle = [NSString stringWithFormat:@"Response to your request"];
    }
    
    // Email Content
    //    NSString *messageBody = @"Here are the links to download either an Android or an iOS hOurworld app.\n\nAndroid : https://play.google.com/store/apps/details?id=edu.psu.ist.mtb_hourworld&hl=en \n\niOS : https://itunes.apple.com/us/app/hourworld/id671499452?mt=8 \n\n";

    NSLog(@"%@ %@ %@ %@", mItem.mSvcCat, mItem.mService, mItem.mDescription, mItem.mEmail);
    
    NSString *messageBody = [NSString stringWithFormat:@"Hi there,\nI'm inquiring about your listing: \"%@ %@, %@\"", mItem.mSvcCat, mItem.mService, mItem.mDescription];

    // To address
    if ([mItem.mEmail isEqual:[NSNull null]]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                          message:@"This member did not provide an email address."
                                                         delegate:nil
                                                cancelButtonTitle:@"Close"
                                                otherButtonTitles:nil, nil];
        [message show];
    }
    else {
        NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", mItem.mEmail]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        
        if ([MFMailComposeViewController canSendMail]) {
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:YES];
            [mc setToRecipients:toRecipents];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
    }
     */
    
    MTBProfilePrivateEmailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBProfilePrivateEmailViewController"];
    [viewController setProfileUserID:(int)mItem.mUserID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"usernameclicked"]) {
        MTBProfileViewController *viewController = (MTBProfileViewController *)[segue destinationViewController];
        [viewController setMemID:mItem.mListMbrID];
    }
    else if ([[segue identifier] isEqualToString: @"MTBTaskEditViewController"]) {
        MTBTaskEditViewController *viewController = (MTBTaskEditViewController *)[segue destinationViewController];
        [viewController setItem:mItem];
        [viewController setIsOffer:mIsOffer];
    }
}

@end

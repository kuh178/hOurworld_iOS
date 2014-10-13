//
//  MTBMessageDetailViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBMessageDetailViewController.h"
#import "MTBProfileViewController.h"
#import "MTBReportHoursViewController.h"
#import "MTBAddMessageViewController.h"
#import "LargeMapViewController.h"

#import "QuartzCore/QuartzCore.h"
#import "AFHTTPRequestOperationManager.h"
#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "TSAlertView.h"
#import "JSON.h"

@interface MTBMessageDetailViewController ()

@end

@implementation MTBMessageDetailViewController

@synthesize mItem;
@synthesize taskInfo, replyBarBtn, removeBarBtn, profileImage, reportHourBarBtn, mapView, locationLabel, usernameBtn, timestampLabel, scrollView, xDayLabel, xDayImage, emailBtn;
@synthesize largeViewBtn;
@synthesize webView;

NSUserDefaults *userDefault;

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
    self.screenName = @"MessageDetailViewController";
}

- (void) showViews {

    // display "remove" btn
    userDefault = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%d", mItem.mListMbrID);
    NSLog(@"memID: %d", [[userDefault objectForKey:@"memID"] intValue]);
    
    if (mItem.mListMbrID == 0) {
        [replyBarBtn setEnabled:NO];
        [reportHourBarBtn setEnabled:NO];
    }
    else {
        [replyBarBtn setEnabled:YES];
        [reportHourBarBtn setEnabled:YES];
    }
    
    // if the service was posted by the user, enable remove and edit features.
    if([[userDefault objectForKey:@"memID"] intValue] == mItem.mListMbrID) {
        [removeBarBtn setEnabled:YES];
    }
    else {
        [removeBarBtn setEnabled:NO];
    }
    
    // handling xDays
    if (mItem.xDays > 7) {
        //[xDayLabel setHidden:YES];
        //[xDayImage setHidden:YES];
        [xDayLabel setText:@"This task will be expired in two weeks"];
    }
    else if (mItem.xDays > 3 && mItem.xDays <= 7) {
        [xDayLabel setHidden:NO];
        [xDayImage setHidden:YES];
        [xDayLabel setText:@"This task will be expired in a week"];
        UIImage *image = [UIImage imageNamed: @"in_a_week.png"];
        [xDayImage setImage:image];
    }
    else if (mItem.xDays > 1 && mItem.xDays <= 3) {
        [xDayLabel setHidden:NO];
        [xDayImage setHidden:YES];
        [xDayLabel setText:@"This task will be expired in three days"];
        UIImage *image = [UIImage imageNamed: @"in_three_days.png"];
        [xDayImage setImage:image];
    }
    else if (mItem.xDays > 0 && mItem.xDays <= 1) {
        [xDayLabel setHidden:NO];
        [xDayImage setHidden:YES];
        [xDayLabel setText:@"This task will be expired in a day"];
        UIImage *image = [UIImage imageNamed: @"in_a_day.png"];
        [xDayImage setImage:image];
    }
    
    // handling username
    if (mItem.mListMbrName != (id)[NSNull null] && [mItem.mListMbrName length] != 0) {
        [usernameBtn setTitle:mItem.mListMbrName forState:UIControlStateNormal];
    }
    else {
        [usernameBtn setTitle:@"Not available" forState:UIControlStateNormal];
    }
    
    // handling timestamp
    if (mItem.mTimestamp != (id)[NSNull null]) {
        NSArray *splitTimestamp = [mItem.mTimestamp componentsSeparatedByString:@" "];
        timestampLabel.text = [NSString stringWithFormat:@"Posted: %@", splitTimestamp[0]];
    }
    else {
        timestampLabel.text = @"No datetime found";
    }
    
    // handling eBlast
    taskInfo.frame = [self calculateSize2:mItem.mEblast TextView:taskInfo];
    if (mItem.mEblast != (id)[NSNull null] && [mItem.mEblast length] != 0) {
        taskInfo.text = mItem.mEblast;
    }
    else {
        taskInfo.text = @"No messages found";
    }
    
    // we are currently useing a webview to display description
    NSString *htmlString = [NSString stringWithFormat:@"<font face='Helvetica' size='3'>%@", mItem.mEblast];
    NSLog(@"htmlString : %@", htmlString);
    
    [webView loadHTMLString:htmlString baseURL:nil];
    
    /*
    // update other IBOutlets as well.
    locationLabel.frame = CGRectMake(locationLabel.frame.origin.x,
                                     locationLabel.frame.origin.y + taskInfo.frame.size.height,
                                     locationLabel.frame.size.width,
                                     locationLabel.frame.size.height);
    
    mapView.frame = CGRectMake(mapView.frame.origin.x,
                               mapView.frame.origin.y + (taskInfo.frame.size.height * 0.8),
                               mapView.frame.size.width,
                               mapView.frame.size.height);
    
    largeViewBtn.frame = CGRectMake(largeViewBtn.frame.origin.x,
                                    largeViewBtn.frame.origin.y + (taskInfo.frame.size.height * 0.8),
                                    largeViewBtn.frame.size.width,
                                    largeViewBtn.frame.size.height);
    */
    
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
        [locationLabel setHidden:NO];
        //[locationLabel setText:@"No location info"];
        [largeViewBtn setHidden:YES];
        
        scrollView.contentSize = CGSizeMake(320, taskInfo.frame.size.height);
    }
    else { // add a pushpin in the map.
        [mapView setHidden:NO];
        [locationLabel setHidden:NO];
        [largeViewBtn setHidden:NO];
        
        mapView.delegate = self;
        CLLocationCoordinate2D location;
        location.latitude = mItem.mDLat;
        location.longitude = mItem.mDLon;
        
        LocationAnnotation *locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:location];
        [mapView addAnnotation:locationAnnotation];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 3000, 3000);
        
        [mapView setRegion:region animated:FALSE];
        [mapView regionThatFits:region];
        
        //scrollView.contentSize = CGSizeMake(320, taskInfo.frame.size.height + locationLabel.frame.size.height + mapView.frame.size.height + 230);
        
        scrollView.contentSize = CGSizeMake(320, locationLabel.frame.size.height + mapView.frame.size.height + 230);
    }
}

- (CGRect) calculateSize:(NSString *)pInput Label:(UILabel *)pLabel {
    
    // FLT_MAX here simply means no constraint in height
    //CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    //CGSize expectedLabelSize = [pInput sizeWithFont:pLabel.font constrainedToSize:maximumLabelSize lineBreakMode:pLabel.lineBreakMode];
    
    CGSize expectedLabelSize = [pInput sizeWithAttributes:@{NSFontAttributeName:pLabel.font}];
    
    //adjust the label the the new height.
    CGRect newFrame = pLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    
    return newFrame;
}

- (CGRect) calculateSize2:(NSString *)pInput TextView:(UITextView *)pTextView {
    
    // FLT_MAX here simply means no constraint in height
    //CGSize maximumTextViewSize = CGSizeMake(296, FLT_MAX);
    //CGSize expectedTextViewSize = [pInput sizeWithFont:pTextView.font constrainedToSize:maximumTextViewSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize expectedTextViewSize = [pInput sizeWithAttributes:@{NSFontAttributeName:pTextView.font}];
    
    //adjust the label the the new height.
    CGRect newFrame = pTextView.frame;
    newFrame.size.height = expectedTextViewSize.height + 25;
    
    return newFrame;
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"%d", mItem.mListMbrID);
    
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

// ref: http://iosdevtricks.blogspot.com/2013/04/creating-custom-alert-view-for-iphone.html
-(IBAction)pressReplyBtn:(id)sender {
    // show a reply dialog
    /*
    TSAlertView *alertView = [[TSAlertView alloc]init];

    [alertView setTitle:@"Add your message"];
    [alertView setStyle:TSAlertViewStyleInput];
    [alertView addButtonWithTitle:@"Reply"];
    [alertView addButtonWithTitle:@"Close"];
    [alertView setDelegate:self];
    [alertView show];
    */
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add your message?" message:@"" delegate:self cancelButtonTitle:@"Reply" otherButtonTitles:@"Close", nil] ;
    alertView.tag = 3;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
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

-(IBAction)pressremoveBtn:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                            message:@"Remove this message?"
                                            delegate:self
                                            cancelButtonTitle:@"Remove"
                                            otherButtonTitles:@"Cancel", nil];
    [message show];

}

-(IBAction)pressLargeViewBtn:(id)sender {
    
    LargeMapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LargeMapViewController"];
    [viewController setLatitude:mItem.mDLat];
    [viewController setLongitude:mItem.mDLon];
    [self.navigationController pushViewController:viewController animated:YES];

}

/*
- (void)TSAlertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    NSLog(@"reply: %@", title);
    
    if([title isEqualToString:@"Reply"])
    {
        // upload a reply to the server
        // check the text
        // alertView.inputTextField.text
        NSString *addedReply = alertView.inputTextField.text;
        
        if([addedReply isEqual:@""]) {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Please check a message"];
            [dialog addButtonWithTitle:@"Close"];
            [dialog show];
        }
        else {
            // submit the message
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"ReplyMsg,%d:%d", mItem.mPostNum, mItem.mListMbrID],
                                     @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                     @"EID"             :[userDefault objectForKey:@"EID"],
                                     @"memID"           :[userDefault objectForKey:@"memID"],
                                     @"message"         :[NSString stringWithFormat:@"%@", addedReply]};
            
            [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                      // Use when fetching text data
                      NSString *responseString = [responseObject responseString];
                      
                      // parse JSON and insert data into db
                      NSMutableDictionary *result = nil;
                      result = [responseString JSONValue];
                      
                      if([result objectForKey:@"success"]) {
                          NSLog(@"Complete uploading a reply");
                          
                          [userDefault setInteger:1 forKey:@"reload"];
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      else {
                          NSLog(@"Fail to upload a message");
                          
                          UIAlertView *dialog = [[UIAlertView alloc]init];
                          [dialog setDelegate:self];
                          [dialog setTitle:@"Message"];
                          [dialog setMessage:@"Failed to post your reply. Please try again"];
                          [dialog addButtonWithTitle:@"Close"];
                          [dialog show];
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", operation);
                  }];
        }
    }
    else if([title isEqualToString:@"Close"])
    {
        NSLog(@"Close");
    }
}
*/

- (void)removeMessage {
    
    // submit the message
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"DelMsg,%d:%d", mItem.mPostNum, mItem.mListMbrID],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([responseObject objectForKey:@"success"]) {
                  
                  [userDefault setInteger:1 forKey:@"reload"];
                  [self.navigationController popViewControllerAnimated:YES];
              }
              else {
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"Failed to remove your message. Please try again"];
                  [dialog addButtonWithTitle:@"Close"];
                  [dialog show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
 
    // this are hard-coded values
    mItem.mSvcCatID = 1000;
    mItem.mSvcID = 1009;
    
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
    else if([title isEqualToString:@"Remove"]) {
        [self removeMessage];
    }
    else if([title isEqualToString:@"Reply"])
    {
        // upload a reply to the server
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSString *addedReply = alertTextField.text;
        
        // check the text
        if([addedReply isEqual:@""]) {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Please check a message"];
            [dialog addButtonWithTitle:@"Close"];
            [dialog show];
        }
        else {
            // submit the message
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"ReplyMsg,%d:%d", mItem.mPostNum, mItem.mListMbrID],
                                     @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                     @"EID"             :[userDefault objectForKey:@"EID"],
                                     @"memID"           :[userDefault objectForKey:@"memID"],
                                     @"message"         :[NSString stringWithFormat:@"%@", addedReply]};
            
            [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                    NSLog(@"responseObject: %@", responseObject);
    
                    if([responseObject objectForKey:@"success"]) {
                        NSLog(@"Complete uploading a reply");
        
                        [userDefault setInteger:1 forKey:@"reload"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        NSLog(@"Fail to upload a message");
        
                        UIAlertView *dialog = [[UIAlertView alloc]init];
                        [dialog setDelegate:self];
                        [dialog setTitle:@"Message"];
                        [dialog setMessage:@"Failed to post your reply. Please try again"];
                        [dialog addButtonWithTitle:@"Close"];
                        [dialog show];
                    }
    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", operation);
                }];
            }
        }
}


- (void)viewWillAppear:(BOOL)animated
{
    /*
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Details"];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
     */
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [super viewWillAppear:animated];
}

-(IBAction)pressEmailBtn:(id)sender {
    NSString *emailTitle = @"Download the hOurworld mobile app now!";

    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Hi there,\nI'm inquiring about your listing: %@", mItem.mEblast];
    
    NSLog(@"%@ %@", mItem.mEblast, mItem.mEmail);
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", mItem.mEmail]];
    
    NSLog(@"%@", [toRecipents objectAtIndex:0]);
    
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
    
    else {
        
    }
}


@end

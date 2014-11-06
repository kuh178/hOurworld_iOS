//
//  MainPageViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 1/21/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MainPageViewController.h"
#import "MTBLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTBTaskCategoryViewController.h"
#import "MTBReportHourFromMainViewController.h"
#import "JSON.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

@synthesize announcementBtn, reportHoursBtn, indicator, locationLabel;

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
    //UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    //statusBarView.backgroundColor = [UIColor colorWithRed:(18/255.0) green:(165/255.0) blue:(244/255.0) alpha:1];
    //[self.view addSubview:statusBarView];
}

/*
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"logged_in"] isEqualToString:@"1"]) {
        // do nothing...
    }
    else {
        MTBLoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MainPageViewController";
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

-(void) reportHours {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{@"requestType"     :@"RecordHrs,0",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([responseObject objectForKey:@"success"]) {
                  NSLog(@"Complete reporting hour");
                  
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:@"Message"];
                  [dialog setMessage:@"Your hour has been reported"];
                  [dialog addButtonWithTitle:@"Close"];
                  [dialog show];
              }
              else {
                  NSLog(@"Fail to report hour");
              }
              
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];

}

-(IBAction)announcementBtnPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send email", @"Report hours (1h)",nil];
    [alert show];
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

-(IBAction)reportHoursBtnPressed:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Did you provide or receive the service?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Provided", @"Received", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Provided"])
    {
        NSLog(@"Provided");
        MTBReportHourFromMainViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHourFromMainViewController"];
        [viewController setIsProvider:@"T"];
        [viewController setIsReceiver:@"F"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([title isEqualToString:@"Received"])
    {
        NSLog(@"Received");
        MTBReportHourFromMainViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHourFromMainViewController"];
        [viewController setIsProvider:@"F"];
        [viewController setIsReceiver:@"T"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([title isEqualToString:@"Send email"]) {
        NSLog(@"Send email");
        
        NSString *emailTitle = @"Download the hOurworld mobile app now!";
        // Email Content
        //    NSString *messageBody = @"Here are the links to download either an Android or an iOS hOurworld app.\n\nAndroid : https://play.google.com/store/apps/details?id=edu.psu.ist.mtb_hourworld&hl=en \n\niOS : https://itunes.apple.com/us/app/hourworld/id671499452?mt=8 \n\n";
        
        NSString *messageBody = @"Hello,<br><br>I want to share this great hOurworld mobile app with you. Download the app now and earn an hour credit!<br><br>Are you an iOS user? Click <a href=\"https://itunes.apple.com/us/app/hourworld/id671499452?mt=8\">here</a> to download!<br><br>Are you an Android user? Click <a href=\"https://play.google.com/store/apps/details?id=edu.psu.ist.mtb_hourworld&hl=en\">here</a> to download! <br><br>If you're not a timebank member, go to the \"Join\" tab here: <a href=\"http://www.hourworld.org/\">www.hourworld.org</a> and select your nearest exchange. You must do this for the mobile app to work. Please be patient after signing up. The administrator will contact you to confirm your identity.";
        
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@""];
        
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
    else if([title isEqualToString:@"Report hours (1h)"]){
        // report hours
        [self reportHours];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBTaskCategoryViewController_Offer"]) {
        
        MTBTaskCategoryViewController *viewController = (MTBTaskCategoryViewController *)[segue destinationViewController];
        [viewController setIsOffer:@"T"];
        [viewController setIsRequest:@"F"];
    }
    else if ([[segue identifier] isEqualToString: @"MTBTaskCategoryViewController_Request"]) {
        
        MTBTaskCategoryViewController *viewController = (MTBTaskCategoryViewController *)[segue destinationViewController];
        [viewController setIsOffer:@"F"];
        [viewController setIsRequest:@"T"];
    }
}


@end

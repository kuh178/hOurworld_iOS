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
// https://github.com/workshirt/WSCoachMarksView
#import "WSCoachMarksView.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

@synthesize announcementBtn, reportHoursBtn, infoBtn, indicator, locationLabel;
WSCoachMarksView *coachMarksView;
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
    //UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    //statusBarView.backgroundColor = [UIColor colorWithRed:(18/255.0) green:(165/255.0) blue:(244/255.0) alpha:1];
    //[self.view addSubview:statusBarView];
    
    NSArray *coachMarks;
    userDefault = [NSUserDefaults standardUserDefaults];
    
    if([[userDefault objectForKey:@"size"] isEqual:@"4.0"]) {
        coachMarks = @[
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){37.0f, 211.0f, 118.0f, 91.0f}],
                           @"caption": @"\"Announcements\" shows a list of services that will be expired in two weeks"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){193.0f, 211.0f, 70.0f, 91.0f}],
                           @"caption": @"\"Offers\" shows a list of standing offers by a category"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){55.0f, 322.0f, 80.0f, 91.0f}],
                           @"caption": @"\"Requests\" shows a list of standing requests by a category"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){193.0f, 322.0f, 70.0f, 91.0f}],
                           @"caption": @"\"Search\" allows you to search services and members"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){60.0f, 433.0f, 70.0f, 91.0f}],
                           @"caption": @"\"Hours\" allows you to report hours"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){193.0f, 433.0f, 70.0f, 91.0f}],
                           @"caption": @"\"More\" includes a Group feature, My profile, About this app and Version"
                           },
                       ];
    }
    else {
        
        coachMarks = @[
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){38.0f, 191.0f, 118.0f, 83.0f}],
                           @"caption": @"\"Announcements\" shows a list of services that will be expired in two weeks"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){197.0f, 191.0f, 60.0f, 83.0f}],
                           @"caption": @"\"Offers\" shows a list of standing offers by a category"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){61.0f, 287.0f, 70.0f, 83.0f}],
                           @"caption": @"\"Requests\" shows a list of standing requests by a category"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){197.0f, 287.0f, 60.0f, 83.0f}],
                           @"caption": @"\"Search\" allows you to search services and members"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){65.0f, 383.0f, 60.0f, 83.0f}],
                           @"caption": @"\"Hours\" allows you to report hours"
                           },
                       @{
                           @"rect": [NSValue valueWithCGRect:(CGRect){197.0f, 383.0f, 60.0f, 83.0f}],
                           @"caption": @"\"More\" includes a Group feature, My profile, About this app and Version"
                           },
                       ];

    }
    
    coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
    
    /*
    if([[userDefault objectForKey:@"size"] isEqual:@"4.0"] &&
       [[userDefault objectForKey:@"firstTime"] isEqual:@"T"]) {
        
        [userDefault setValue:@"F" forKey:@"firstTime"];
        
        [self.navigationController.view addSubview:coachMarksView];
        [coachMarksView start];
    }
    */
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
        [self checkUserLoggedIn];
    }
    else {
        MTBLoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    // check if the user logged-in
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MainPageViewController";
    
    // Show coach marks
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"];
    if (coachMarksShown == NO) {
        // Don't show again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Show coach marks
        [coachMarksView start];
        
        // Or show coach marks after a second delay
        // [coachMarksView performSelector:@selector(start) withObject:nil afterDelay:1.0f];
    }
}

- (void) checkUserLoggedIn {
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
        
            NSLog(@"responseObject : %@", responseObject);
            
            
            if([[responseObject objectForKey:@"success"] intValue] == 1) {
                NSLog(@"success : %@", [responseObject objectForKey:@"success"]);
            }
            else {
                NSLog(@"Account expired need to re-login");
                
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:@"Your account has been expired. Please login again"];
                [dialog addButtonWithTitle:@"Login"];
                [dialog show];
            }
            
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", operation);
        }];

}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
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
    else if([title isEqualToString:@"Login"]) {

        // reset everything
        NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
        
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for(int i=0 ; i<[viewControllers count] ; i++){
            
            id obj=[viewControllers objectAtIndex:i];
            
            NSLog(@"%@", [obj class]);
            
            if([obj isKindOfClass:[MTBLoginViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
        
        // go to the login page
        MTBLoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        
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

-(IBAction)infoBtnPressed:(id)sender {

    [userDefault setValue:@"F" forKey:@"firstTime"];
    
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
}


@end

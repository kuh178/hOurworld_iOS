//
//  LoginViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBLoginViewController.h"
#import "MTBLoginActionViewController.h"
#import "FirstViewController.h"

@interface MTBLoginViewController ()

@end

@implementation MTBLoginViewController

@synthesize registerBtn;
@synthesize loginBtn;

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
    
    NSString *messageText = @"hOurworld is a national network of Hour Exchanges (time banks) in which you can provide a service, bank the time taken to provide it and then spend the hours you have earned to get services you want. This hOurworld mobile app is the product of a partnership among hOurworld, the Center for Human Computer Interaction at Pennsylvania State University (PSU), and the Palo Alto Research Center (PARC).";
    
    //\n\nResearchers at PSU and PARC want to understand how hOurworld members will use this mobile app and how mobile technology would influences time banking activities and social interaction and engagement. By using this application, you agree to share data from your experiences and uses of it. However you can opt out of this study whenever you want. Your information will be kept confidential in accordance with to HIPAA standards, and that any data that is publicized will be stripped of any personally identifying information. For further information on this study, please contact Dr. Jack Carroll (jmcarroll@psu.edu) or Dr. Victoria Bellotti (Victoria.Bellotti@parc.com).
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Terms of service"
                                                      message:messageText
                                                     delegate:self
                                            cancelButtonTitle:@"I understand"
                                            otherButtonTitles:nil];
    message.cancelButtonIndex = -1;
    [message show];
    
    registerBtn.layer.cornerRadius = 5;//half of the width
    //registerBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    registerBtn.layer.borderWidth=1.0f;
    
    loginBtn.layer.cornerRadius = 5;//half of the width
    //loginBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth=1.0f;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"I understand"])
    {
        
    }
    else if([title isEqualToString:@"Not participate"])
    {
       
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnPressed:(id)sender {
    
}

- (IBAction)loginBtnPressed:(id)sender {
    MTBLoginActionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBLoginActionViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.screenName = @"LoginViewController";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end

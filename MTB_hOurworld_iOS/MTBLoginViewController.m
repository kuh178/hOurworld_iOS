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
    
    NSString *messageText = [NSString stringWithFormat:NSLocalizedString(@"Intro_message", nil)];
    
    //\n\nResearchers at PSU and PARC want to understand how hOurworld members will use this mobile app and how mobile technology would influences time banking activities and social interaction and engagement. By using this application, you agree to share data from your experiences and uses of it. However you can opt out of this study whenever you want. Your information will be kept confidential in accordance with to HIPAA standards, and that any data that is publicized will be stripped of any personally identifying information. For further information on this study, please contact Dr. Jack Carroll (jmcarroll@psu.edu) or Dr. Victoria Bellotti (Victoria.Bellotti@parc.com).
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Terms_of_service", nil)]
                                                      message:messageText
                                                     delegate:self
                                            cancelButtonTitle:[NSString stringWithFormat:NSLocalizedString(@"I_understand", nil)]
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
    
    if([title isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"I_understand", nil)]])
    {
        
    }
    else if([title isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"Not_participate", nil)]])
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

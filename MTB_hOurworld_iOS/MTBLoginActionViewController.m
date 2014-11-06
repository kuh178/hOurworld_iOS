//
//  MTBLoginActionViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBLoginActionViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FirstViewController.h"
#import "MainPageViewController.h"
#import "JSON.h"

// this is for creating a md5 string
#import <CommonCrypto/CommonDigest.h>

@interface MTBLoginActionViewController ()

@end

@implementation MTBLoginActionViewController

@synthesize accountTextField, passwordTextField, sendMessageBtn;

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
    
    sendMessageBtn.layer.cornerRadius = 5;//half of the width
    //sendMessageBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    sendMessageBtn.layer.borderWidth=1.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"LoginActionViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) createChallenge {
    
    NSString *returnVal = [[NSString alloc] init];
    
    for (int i = 0 ; i < 80 ; i++) {
        NSInteger randNum = rand() % (15-0) + 0;

        NSString *randNumStr = [NSString stringWithFormat:@"%ld", (long)randNum];
        
        returnVal = [returnVal stringByAppendingString:randNumStr];
    }
    
    NSLog(@"%@", returnVal);
    
    return returnVal;
    
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (IBAction)loginBtnPressed:(id)sender {
    
    if ([accountTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please check your account/password"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else {
        // create a challenge
        NSString *challenge = [self createChallenge];
        NSLog(@"challenge: %@", challenge);
        
        // create a response
        NSString *passwordMd5 = [self md5:passwordTextField.text];
        NSString *mixedMd5 = [self md5:[challenge stringByAppendingFormat:passwordMd5]];
        NSLog(@"mixed md5: %@", mixedMd5);
        NSLog(@"username: %@", accountTextField.text);
        
	    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	    NSDictionary *params = @{@"username"        :[NSString stringWithFormat:@"%@", accountTextField.text],
	                             @"challenge"       :[NSString stringWithFormat:@"%@", challenge],
	                             @"response"        :[NSString stringWithFormat:@"%@", mixedMd5]};
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            if([[responseObject objectForKey:@"success"] boolValue]) { // successfully login
                      
                NSMutableDictionary *jObj = [responseObject objectForKey:@"results"];
                      
                NSLog(@"access_token : %@", [jObj objectForKey:@"access_token"]);
                NSLog(@"EID : %i", [[jObj objectForKey:@"EID"] intValue]);
                NSLog(@"memID : %i", [[jObj objectForKey:@"memID"] intValue]);
                NSLog(@"orgID : %i", [[jObj objectForKey:@"orgID"] intValue]);
                      
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[jObj objectForKey:@"access_token"] forKey:@"access_token"];
                [userDefault setObject:[NSString stringWithFormat:@"%i", [[jObj objectForKey:@"EID"] intValue]] forKey:@"EID"];
                [userDefault setObject:[NSString stringWithFormat:@"%i", [[jObj objectForKey:@"memID"] intValue]] forKey:@"memID"];
                [userDefault setObject:[NSString stringWithFormat:@"%i", [[jObj objectForKey:@"orgID"] intValue]] forKey:@"orgID"];
                [userDefault setObject:[NSString stringWithFormat:@"1"] forKey:@"logged_in"];
                      
                MainPageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else {
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:@"Wrong Account/Password. Please try again."];
                [dialog addButtonWithTitle:@"OK"];
                [dialog show];
            }
                  
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@\n\n%@", operation, error);
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
    if (textField.frame.origin.y + textField.frame.size.height > 480 - 216) {
        double offset = 480 - 216 - textField.frame.origin.y - textField.frame.size.height - 20;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    
    if (textField.frame.origin.y + textField.frame.size.height > 480 - 216) {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, iOSDeviceScreenSize.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Login to hOurworld"];
    [super viewWillAppear:animated];
}

@end

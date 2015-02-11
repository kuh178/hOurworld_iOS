//
//  MTBProfilePrivateEmailViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 2/9/15.
//  Copyright (c) 2015 HCI PSU. All rights reserved.
//

#import "MTBProfilePrivateEmailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBProfilePrivateEmailViewController ()

@end

@implementation MTBProfilePrivateEmailViewController

@synthesize sendEmailBtn, subject, emailDescription, profileUserID;
NSString *emailDescriptionText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Sending a private email";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MTBProfilePrivateEmailViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [emailDescription endEditing:YES];
}


-(IBAction)sendEmailBtnPressed:(id)sender {
    emailDescriptionText = emailDescription.text;
    
    if([emailDescriptionText isEqual:@""] || [subject.text isEqual:@""]
       || [emailDescriptionText isEqual:[NSNull null]] || [subject isEqual:[NSNull null]]
       || [emailDescriptionText rangeOfString:@"null"].location != NSNotFound) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please check email title or message"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"Reply",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"toID"            :[NSString stringWithFormat:@"%d", profileUserID],
                                 @"subject"         :[NSString stringWithFormat:@"%@", subject.text],
                                 @"message"         :[NSString stringWithFormat:@"%@", emailDescriptionText]};
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if([responseObject objectForKey:@"success"]) {
        NSLog(@"Complete sending an email");
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Email sent!"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Fail to upload a message");
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Failed to send an email. Please try again"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", operation);
}];
    }
}

@end

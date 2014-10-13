//
//  MTBProfileEditContactViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/18/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBProfileEditContactViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBProfileEditContactViewController ()

@end

@implementation MTBProfileEditContactViewController

@synthesize websiteTextField, email1TextField, homeTextField, mobileTextField;
@synthesize websiteBtn, emailBtn, homeBtn, mobileBtn;
@synthesize website, email1, home1, mobile;

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
    
    email1TextField.text = email1;
    mobileTextField.text = mobile;
    homeTextField.text = home1;
    websiteTextField.text = website;
    
    websiteBtn.layer.cornerRadius = 5;//half of the width
    websiteBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    websiteBtn.layer.borderWidth=1.0f;
    
    emailBtn.layer.cornerRadius = 5;//half of the width
    emailBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    emailBtn.layer.borderWidth=1.0f;
    
    homeBtn.layer.cornerRadius = 5;//half of the width
    homeBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    homeBtn.layer.borderWidth=1.0f;
    
    mobileBtn.layer.cornerRadius = 5;//half of the width
    mobileBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    mobileBtn.layer.borderWidth=1.0f;
    
    NSLog(@"%@ %@ %@ %@", email1, home1, mobile, website);
    
    if ([email1 isEqual:@""] || ([email1 length] < 1)) {
        [emailBtn setEnabled:NO];
        [email1TextField setEnabled:NO];
        [email1TextField setText:@"Unavailable"];
    }
    else if ([home1 isEqual:@""] || ([home1 length] < 1)) {
        [homeBtn setEnabled:NO];
        [homeTextField setEnabled:NO];
        [homeTextField setText:@"Unavailable"];
    }
    else if ([mobile isEqual:@""] || ([mobile length] < 1)) {
        [mobileBtn setEnabled:NO];
        [mobileTextField setEnabled:NO];
        [mobileTextField setText:@"Unavailable"];
    }
    else if ([website isEqual:@""] || ([website length] < 1)) {
        [websiteBtn setEnabled:NO];
        [websiteTextField setEnabled:NO];
        [websiteTextField setText:@"Unavailable"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)update:(NSString *)pType content:(NSString *)pContent {
    
 
    if([pContent isEqual:@""]
       || [pContent isEqual:[NSNull null]]
       || [pContent rangeOfString:@"null"].location != NSNotFound) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please check the content"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"EditContact,SAVE",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"Type"            :[NSString stringWithFormat:@"%@", pType],
                                 @"Contact"         :[NSString stringWithFormat:@"%@", pContent],
                                 @"Private"         :@"F"};
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                  if([responseObject objectForKey:@"success"]) {
                      NSLog(@"Complete uploading a message");
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Updated!"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                      
                  }
                  else {
                      NSLog(@"Fail to upload a message");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Failed to update. Please try again"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", operation);
              }];
    }
}

-(IBAction)pressEmailBtn:(id)sender {
    [self update:@"Email1" content:email1TextField.text];
}

-(IBAction)pressMobileBtn:(id)sender {
    [self update:@"Mobile" content:mobileTextField.text];
}

-(IBAction)pressHomeBtn:(id)sender {
    [self update:@"Home1" content:homeTextField.text];
}

-(IBAction)pressWebsiteBtn:(id)sender {
    [self update:@"Website" content:websiteTextField.text];
}

- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

@end

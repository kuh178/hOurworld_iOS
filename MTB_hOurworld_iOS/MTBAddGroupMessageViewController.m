//
//  MTBAddGroupMessageViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBAddGroupMessageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBAddGroupMessageViewController ()

@end

@implementation MTBAddGroupMessageViewController

@synthesize message, submitBtn, groupID;

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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Send a group message";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pressSubmitBtn:(id)sender {
    NSString *addedMessage = message.text;
    
    if([addedMessage isEqual:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please check a message"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"AddMsg,0",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"groupID"         :[NSString stringWithFormat:@"%d", groupID],
                                 @"groupMsg"        :[NSString stringWithFormat:@"%@", addedMessage]};
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                  if([responseObject objectForKey:@"success"]) {
                      NSLog(@"Complete uploading a message");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:self];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Your group message has been posted!"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                      
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else {
                      NSLog(@"Fail to upload a message");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:self];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Failed to post your group message. Please try again"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", operation);
              }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end

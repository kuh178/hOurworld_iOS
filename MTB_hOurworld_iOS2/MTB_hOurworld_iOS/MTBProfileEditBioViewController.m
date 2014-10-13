//
//  MTBProfileEditBioViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/18/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBProfileEditBioViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBProfileEditBioViewController ()

@end

@implementation MTBProfileEditBioViewController

@synthesize bioDescription, bioTextView, doneBtn;

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
    
    // add borderline
    bioTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    bioTextView.layer.borderWidth = 1.0f;
    
    bioTextView.text = bioDescription;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [bioTextView endEditing:YES];
}

-(IBAction)pressDoneBtn:(id)sender {
    bioDescription = bioTextView.text;
    
    NSLog(@"bioDescription: %@", bioDescription);
    
    if([bioDescription isEqual:@""]
       || [bioDescription isEqual:[NSNull null]]
       || [bioDescription rangeOfString:@"null"].location != NSNotFound
       || [bioDescription isEqualToString:@"Add a thorough description"]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please add a bio description"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"EditBio,SAVE",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"Bio"             :[NSString stringWithFormat:@"%@", bioDescription]};
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                  if([responseObject objectForKey:@"success"]) {
                      NSLog(@"Complete uploading a bio");
                      
                      NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                      [userDefault setInteger:1 forKey:@"reload"];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else {
                      NSLog(@"Fail to upload a message");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Failed to update your bio. Please try again"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", operation);
              }];
    }
}

@end

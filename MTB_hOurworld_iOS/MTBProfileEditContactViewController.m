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
@synthesize websiteDelBtn, emailDelBtn, homeDelBtn, mobileDelBtn;
@synthesize emailSeg, mobileSeg, homeSeg, websiteSeg;

bool emailAdd, homeAdd, mobileAdd, websiteAdd = NO;

NSMutableArray *contentArray;

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
    
    // buttons
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
    
    websiteDelBtn.layer.cornerRadius = 5;//half of the width
    websiteDelBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    websiteDelBtn.layer.borderWidth=1.0f;
    
    emailDelBtn.layer.cornerRadius = 5;//half of the width
    emailDelBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    emailDelBtn.layer.borderWidth=1.0f;
    
    homeDelBtn.layer.cornerRadius = 5;//half of the width
    homeDelBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    homeDelBtn.layer.borderWidth=1.0f;
    
    mobileDelBtn.layer.cornerRadius = 5;//half of the width
    mobileDelBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    mobileDelBtn.layer.borderWidth=1.0f;
    
    [self downloadContact];
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

-(void)downloadContact {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"EditContact,EDIT"],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject : %@", responseObject);
            contentArray = [NSMutableArray arrayWithCapacity:0];
            [contentArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            NSString *email1, *mobile, *home1, *website;
            
            for (int i = 0 ; i < [contentArray count] ; i++) {
                
                NSMutableDictionary *item = [contentArray objectAtIndex:i];
                
                NSLog(@"item : %@", item);
                
                if ([[item objectForKey:@"contactType"] isEqualToString:@"Email1"]) {
                    email1TextField.text = [item objectForKey:@"contactInfo"];
                    email1 = [item objectForKey:@"contactInfo"];
                    
                    if([[item objectForKey:@"contactPriv"] isEqualToString:@"T"]) {
                        emailSeg.selectedSegmentIndex = 0;
                    }
                    else {
                        emailSeg.selectedSegmentIndex = 1;
                    }
                }
                if ([[item objectForKey:@"contactType"] isEqualToString:@"Mobile"]) {
                    mobileTextField.text = [item objectForKey:@"contactInfo"];
                    mobile = [item objectForKey:@"contactInfo"];
                    
                    if([[item objectForKey:@"contactPriv"] isEqualToString:@"T"]) {
                        mobileSeg.selectedSegmentIndex = 0;
                    }
                    else {
                        mobileSeg.selectedSegmentIndex = 1;
                    }
                }
                if ([[item objectForKey:@"contactType"] isEqualToString:@"Home1"]) {
                    homeTextField.text = [item objectForKey:@"contactInfo"];
                    home1 = [item objectForKey:@"contactInfo"];
                    
                    if([[item objectForKey:@"contactPriv"] isEqualToString:@"T"]) {
                        homeSeg.selectedSegmentIndex = 0;
                    }
                    else {
                        homeSeg.selectedSegmentIndex = 1;
                    }
                }
                if ([[item objectForKey:@"contactType"] isEqualToString:@"Website"]) {
                    websiteTextField.text = [item objectForKey:@"contactInfo"];
                    website = [item objectForKey:@"contactInfo"];
                    
                    if([[item objectForKey:@"contactPriv"] isEqualToString:@"T"]) {
                        websiteSeg.selectedSegmentIndex = 0;
                    }
                    else {
                        websiteSeg.selectedSegmentIndex = 1;
                    }
                }
                else {
                    // nothing
                }
            }
            
            NSLog(@"%@ %@ %@ %@", email1, home1, mobile, website);
            
            // change the button text
            if ([email1 length] == 0) {
                [emailBtn setEnabled:YES];
                [email1TextField setEnabled:YES];
                [email1TextField setText:@""];
                [emailBtn setTitle:@"Add" forState:UIControlStateNormal];
                emailAdd = YES;
            }
            if ([home1 length] == 0) {
                [homeBtn setEnabled:YES];
                [homeTextField setEnabled:YES];
                [homeTextField setText:@""];
                [homeBtn setTitle:@"Add" forState:UIControlStateNormal];
                homeAdd = YES;
            }
            if ([mobile length] == 0) {
                [mobileBtn setEnabled:YES];
                [mobileTextField setEnabled:YES];
                [mobileTextField setText:@""];
                [mobileBtn setTitle:@"Add" forState:UIControlStateNormal];
                mobileAdd = YES;
            }
            if ([website length] == 0) {
                [websiteBtn setEnabled:YES];
                [websiteTextField setEnabled:YES];
                [websiteTextField setText:@""];
                [websiteBtn setTitle:@"Add" forState:UIControlStateNormal];
                websiteAdd = YES;
            }

    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", operation);
        }];
}

-(void)update:(NSString *)pType content:(NSString *)pContent isAdd:(BOOL)pIsAdd isPrivate:(NSInteger)pIsPrivate{
    
 
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
        if([pType isEqual:@"Home1"] || [pType isEqual:@"Mobile"]) {
            
            pContent = [pContent stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if([pContent length] < 10) {
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:nil];
                [dialog setTitle:@"Error"];
                [dialog setMessage:@"Phone number should be 10-digits"];
                [dialog addButtonWithTitle:@"Close"];
                [dialog show];
                
                return;
            }
            else {
                
                NSString *phone_1 = [pContent substringWithRange:(NSMakeRange(0, 3))];
                NSString *phone_2 = [pContent substringWithRange:(NSMakeRange(3, 3))];
                NSString *phone_3 = [pContent substringWithRange:(NSMakeRange(6, 4))];
                
                pContent = [phone_1 stringByAppendingFormat:@"-%@-%@", phone_2, phone_3];
                
                if ([pType isEqual:@"Home1"]) {
                    [homeTextField setText:pContent];
                }
                else {
                    [mobileTextField setText:pContent];
                }
            }
        }

        // start uploading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
        NSString *requestType = @"";
            
        if (pIsAdd == YES) {
            requestType = @"EditContact,ADD";
        }
        else {
            requestType = @"EditContact,SAVE";
        }
        
        
        NSString *isPrivate = @"";
        if (pIsPrivate == 0) {
            isPrivate = @"T";
        }
        else {
            isPrivate = @"F";
        }
        
        NSLog(@"pIsPrivate: %ld", (long)pIsPrivate);
        
        
        NSLog(@"requestType: %@, pType : %@, pContent : %@, isPrivate : %@", requestType, pType, pContent, isPrivate);
            
        NSDictionary *params = @{@"requestType"     :requestType,
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"Type"            :[NSString stringWithFormat:@"%@", pType],
                                 @"Contact"         :[NSString stringWithFormat:@"%@", pContent],
                                 @"Private"         :[NSString stringWithFormat:@"%@", isPrivate]};
            
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
        
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setInteger:1 forKey:@"reload"];
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
    [self update:@"Email1" content:email1TextField.text isAdd:emailAdd isPrivate:emailSeg.selectedSegmentIndex];
}

-(IBAction)pressMobileBtn:(id)sender {
    [self update:@"Mobile" content:mobileTextField.text isAdd:mobileAdd isPrivate:mobileSeg.selectedSegmentIndex];
}

-(IBAction)pressHomeBtn:(id)sender {
    [self update:@"Home1" content:homeTextField.text isAdd:homeAdd isPrivate:homeSeg.selectedSegmentIndex];
}

-(IBAction)pressWebsiteBtn:(id)sender {
    [self update:@"Website" content:websiteTextField.text isAdd:websiteAdd isPrivate:websiteSeg.selectedSegmentIndex];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textViewDidBeginEditing");
    
    // To load different storyboards on launch
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (textField.frame.origin.y + textField.frame.size.height > 480 - 216) {
            double offset = 480 - 216 - textField.frame.origin.y - textField.frame.size.height;
            CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.view.frame = rect;
            
            [UIView commitAnimations];
        }
    }
    if (iOSDeviceScreenSize.height == 568) {
        if (textField.frame.origin.y + textField.frame.size.height > 568 - 216) {
            double offset = 568 - 216 - textField.frame.origin.y - textField.frame.size.height;
            CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.view.frame = rect;
            
            [UIView commitAnimations];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textViewDidEndEditing");
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, iOSDeviceScreenSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)pressEmailDelBtn:(id)sender {
    [self deleteContact:@"Email1"];
}

-(IBAction)pressMobileDelBtn:(id)sender {
    [self deleteContact:@"Mobile"];
}

-(IBAction)pressHomeDelBtn:(id)sender {
    [self deleteContact:@"Home1"];
}

-(IBAction)pressWebsiteDelBtn:(id)sender {
    [self deleteContact:@"Website"];
}

- (void) deleteContact:(NSString *)pType {
    // start uploading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :@"EditContact,DEL",
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"],
                             @"Type"            :[NSString stringWithFormat:@"%@", pType]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            if([responseObject objectForKey:@"success"]) {
                NSLog(@"Complete uploading a message");
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:nil];
                [dialog setTitle:@"Message"];
                [dialog setMessage:@"Deleted!"];
                [dialog addButtonWithTitle:@"Close"];
                [dialog show];
                
                if ([pType isEqualToString:@"Home1"]) {
                    [homeBtn setTitle:@"Add" forState:UIControlStateNormal];
                    homeTextField.text = @"";
                }
                else if([pType isEqualToString:@"Mobile"]) {
                    [mobileBtn setTitle:@"Add" forState:UIControlStateNormal];
                    mobileTextField.text = @"";
                }
                else if([pType isEqualToString:@"Website"]) {
                    [websiteBtn setTitle:@"Add" forState:UIControlStateNormal];
                    websiteTextField.text = @"";
                }
        
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setInteger:1 forKey:@"reload"];
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

@end

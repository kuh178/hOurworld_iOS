//
//  MTBRegistrationFinalViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBRegistrationFinalViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface MTBRegistrationFinalViewController ()

@end

@implementation MTBRegistrationFinalViewController

@synthesize password, passwordAgain, bio, phone;
@synthesize myFName, myLName, myStreet, myCity, myState, myZipcode, myBirthMonth, myBirthDay, myBirthYear, myEmail, submitBtn;
@synthesize memID;

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
    
    submitBtn.layer.cornerRadius = 10;//half of the width
    submitBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    submitBtn.layer.borderWidth=1.0f;
    
    NSLog(@"memID: %d", memID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)proceedRegister {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"AddMbr,%d", memID],
                             @"getRefs"         :@"F",
                             @"Firstname"       :myFName,
                             @"Lastname"        :myLName,
                             @"Street"          :myStreet,
                             @"City"            :myCity,
                             @"State"           :myState,
                             @"Zip"             :myZipcode,
                             @"BDate"           :[NSString stringWithFormat:@"%@/%@/%@", myBirthMonth, myBirthDay, myBirthYear],
                             @"Bio"             :myBio,
                             @"Email"           :myEmail,
                             @"Pwd"             :myPassword,
                             @"Phone"           :myPhone};
    
    NSLog(@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@", [NSString stringWithFormat:@"AddMbr,%d", memID], @"F", myFName, myLName, myStreet, myCity, myState, myZipcode, [NSString stringWithFormat:@"%@/%@/%@", myBirthMonth, myBirthDay, myBirthYear], myBio, myEmail, myPassword,myPhone);
    
    
    [manager POST:@"http://www.hourworld.org/db_mob/onJoin.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
              if([responseObject objectForKey:@"success"]) {
                  NSLog(@"Complete uploading a task");
                  
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                  [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Registration_success", nil)]];
                  [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
                  [dialog show];
                  
              }
              else {
                  NSLog(@"Fail to upload a task");
                  
                  UIAlertView *dialog = [[UIAlertView alloc]init];
                  [dialog setDelegate:self];
                  [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                  [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Registration_fail", nil)]];
                  [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
                  [dialog show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"Register", nil)]])
    {
        [self proceedRegister];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:[NSString stringWithFormat:NSLocalizedString(@"Create_account_3_3", nil)]];
    [super viewWillAppear:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)] style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

// moving up views when a keyboard appears: http://comxp.tistory.com/181
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if ([textField isEqual:bio]) {
        
        const int movementDistance = -150; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [passwordAgain resignFirstResponder];
    [bio resignFirstResponder];
    [phone resignFirstResponder];
}

-(IBAction)pressSubmitBtn:(id)sender {
    
    myPassword = [password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myPasswordAgain = [passwordAgain.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myPhone = [phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myBio = [bio.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([myPassword length] == 0 ||
        [myPasswordAgain length] == 0 ||
        [myPhone length] == 0 ||
        [myBio length] == 0) {
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Please_fill_out", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
        [dialog show];
    }
    // check if the password and passwordAgain are the same
    else if (![myPassword isEqualToString:myPasswordAgain]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Please_check_password", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
        [dialog show];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]
                                                          message:[NSString stringWithFormat:NSLocalizedString(@"Register_your_account", nil)]
                                                         delegate:self
                                                cancelButtonTitle:[NSString stringWithFormat:NSLocalizedString(@"Register", nil)]
                                                otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"Cancel", nil)], nil];
        [message show];
    }
}

@end

//
//  MTBRegisterationDetailViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBRegisterationDetailViewController.h"
#import "MTBRegistrationFinalViewController.h"
#import "JSON.h"

@interface MTBRegisterationDetailViewController ()

@end

@implementation MTBRegisterationDetailViewController 

@synthesize memID, memName;
@synthesize fName, lName, street, city, state, zipcode, birthMonth, birthDay, birthYear, email;

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
    
    submitBtn.layer.cornerRadius = 5;//half of the width
    //submitBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    submitBtn.layer.borderWidth=1.0f;
}

- (void)pressSubmitBtn {
    
    myFName = [fName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myLName = [lName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myStreet = [street.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myCity = [city.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myState = [state.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myZipcode = [zipcode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myBirthMonth = [birthMonth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myBirthDay = [birthDay.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myBirthYear = [birthYear.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    myEmail = [email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([myFName length] == 0 ||
        [myLName length] == 0 ||
        [myStreet length] == 0 ||
        [myCity length] == 0 ||
        [myState length] == 0 ||
        [myZipcode length] == 0 ||
        [myBirthMonth length] == 0 ||
        [myBirthDay length] == 0 ||
        [myBirthYear length] == 0 ||
        [myEmail length] == 0) {
       
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please fill out all fields"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        MTBRegistrationFinalViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBRegistrationFinalViewController"];
        [viewController setMyFName:myFName];
        [viewController setMyLName:myLName];
        [viewController setMyStreet:myStreet];
        [viewController setMyCity:myCity];
        [viewController setMyState:myState];
        [viewController setMyZipcode:myZipcode];
        [viewController setMyBirthMonth:myBirthMonth];
        [viewController setMyBirthDay:myBirthDay];
        [viewController setMyBirthYear:myBirthYear];
        [viewController setMyEmail:myEmail];
        [viewController setMemID:memID];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Create an account [2/3]"];
    [super viewWillAppear:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    if ([textField isEqual:birthMonth] ||
        [textField isEqual:birthDay] ||
        [textField isEqual:birthYear] ||
        [textField isEqual:email]) {
        
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
    [fName resignFirstResponder];
    [lName resignFirstResponder];
    [street resignFirstResponder];
    [city resignFirstResponder];
    [state resignFirstResponder];
    [zipcode resignFirstResponder];
    [birthMonth resignFirstResponder];
    [birthDay resignFirstResponder];
    [birthYear resignFirstResponder];
    [email resignFirstResponder];
}

-(IBAction)pressNextBtn:(id)sender {
    [self pressSubmitBtn];
}

@end

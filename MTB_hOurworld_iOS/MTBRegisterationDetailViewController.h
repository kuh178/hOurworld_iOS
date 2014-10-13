//
//  MTBRegisterationDetailViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface MTBRegisterationDetailViewController : UIViewController <UITextFieldDelegate> {
    NSString *memName;
    NSInteger memID;

    IBOutlet UITextField *fName;
    IBOutlet UITextField *lName;
    IBOutlet UITextField *street;
    IBOutlet UITextField *city;
    IBOutlet UITextField *state;
    IBOutlet UITextField *zipcode;
    
    IBOutlet UITextField *birthMonth;
    IBOutlet UITextField *birthDay;
    IBOutlet UITextField *birthYear;
    
    IBOutlet UITextField *email;

    
    NSString *myFName;
    NSString *myLName;
    NSString *myStreet;
    NSString *myCity;
    NSString *myState;
    NSString *myZipcode;
    NSString *myBirthMonth;
    NSString *myBirthDay;
    NSString *myBirthYear;
    NSString *myEmail;
    
    
    UITextField *bioText;
    UITextField *phoneText;
    UIButton *submitBtn;
}

@property (nonatomic, retain) NSString *memName;
@property (nonatomic, assign) NSInteger memID;

@property (nonatomic, retain) IBOutlet UITextField *fName;
@property (nonatomic, retain) IBOutlet UITextField *lName;
@property (nonatomic, retain) IBOutlet UITextField *street;
@property (nonatomic, retain) IBOutlet UITextField *city;
@property (nonatomic, retain) IBOutlet UITextField *state;
@property (nonatomic, retain) IBOutlet UITextField *zipcode;
@property (nonatomic, retain) IBOutlet UITextField *birthMonth;
@property (nonatomic, retain) IBOutlet UITextField *birthDay;
@property (nonatomic, retain) IBOutlet UITextField *birthYear;
@property (nonatomic, retain) IBOutlet UITextField *email;

-(IBAction)pressNextBtn:(id)sender;

@end

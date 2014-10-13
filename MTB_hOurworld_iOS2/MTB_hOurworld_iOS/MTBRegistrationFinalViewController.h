//
//  MTBRegistrationFinalViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBRegistrationFinalViewController : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UITextField *password;
    IBOutlet UITextField *passwordAgain;
    IBOutlet UITextField *bio;
    IBOutlet UITextField *phone;
    
    IBOutlet UIButton *submitBtn;
    
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
    
    NSString *myPassword;
    NSString *myPasswordAgain;
    NSString *myPhone;
    NSString *myBio;
    
    int memID;
}

@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UITextField *passwordAgain;
@property (nonatomic, retain) IBOutlet UITextField *bio;
@property (nonatomic, retain) IBOutlet UITextField *phone;

@property (nonatomic, retain) IBOutlet UIButton *submitBtn;

@property (nonatomic, retain) NSString *myFName;
@property (nonatomic, retain) NSString *myLName;
@property (nonatomic, retain) NSString *myStreet;
@property (nonatomic, retain) NSString *myCity;
@property (nonatomic, retain) NSString *myState;
@property (nonatomic, retain) NSString *myZipcode;
@property (nonatomic, retain) NSString *myBirthMonth;
@property (nonatomic, retain) NSString *myBirthDay;
@property (nonatomic, retain) NSString *myBirthYear;
@property (nonatomic, retain) NSString *myEmail;

@property (nonatomic, assign) int memID;

-(IBAction)pressSubmitBtn:(id)sender;

@end

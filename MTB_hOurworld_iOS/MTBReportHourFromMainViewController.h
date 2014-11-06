//
//  MTBReportHourFromMainViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBItem.h"
#import "GAITrackedViewController.h"
#import "MTBChooseMemberViewController.h"
#import "MTBReportHourTaskCategoryViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"

@interface MTBReportHourFromMainViewController : GAITrackedViewController <UITextViewDelegate, MTBChooseMemberViewControllerDelegate, MTBReportHourTaskCategoryViewControllerDelegate> {
    IBOutlet UITextView *note;
    IBOutlet UIButton *addDateBtn;
    IBOutlet UIButton *addHourBtn;
    IBOutlet UIButton *chooseRecipientBtn;
    IBOutlet UIButton *chooseCategoryBtn;
    IBOutlet UIBarButtonItem *submitBtn;
    
    IBOutlet UILabel *satisfactionLabel;
    IBOutlet UILabel *referenceLabel;
    
    //IBOutlet UISwitch *satisfactionSwitch;
    //IBOutlet UISwitch *referenceSwitch;
    IBOutlet UISegmentedControl *satisfactionSwitch;
    IBOutlet UISegmentedControl *referenceSwitch;
    
    NSString *isProvider;
    NSString *isReceiver;
    
    Boolean flag;
    Boolean addDate;
    Boolean addHour;
    double countDownDuration;
    NSString *date;
    NSString *hour;
    
    NSString *satisfaction;
    NSString *reference;
}

@property (nonatomic, retain) IBOutlet UITextView *note;
@property (nonatomic, retain) IBOutlet UIButton *addDateBtn;
@property (nonatomic, retain) IBOutlet UIButton *addHourBtn;
@property (nonatomic, retain) IBOutlet UIButton *chooseRecipientBtn;
@property (nonatomic, retain) IBOutlet UIButton *chooseCategoryBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;

@property (nonatomic, retain) IBOutlet UILabel *satisfactionLabel;
@property (nonatomic, retain) IBOutlet UILabel *referenceLabel;

//@property (nonatomic, retain) IBOutlet UISwitch *satisfactionSwitch;
//@property (nonatomic, retain) IBOutlet UISwitch *referenceSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *satisfactionSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *referenceSwitch;

@property (nonatomic, retain) NSString *isProvider;
@property (nonatomic, retain) NSString *isReceiver;

//-(IBAction)satisfactionSwitch:(id)sender;
//-(IBAction)referenceSwitch:(id)sender;

-(IBAction)pressAddDateBtn:(id)sender;
-(IBAction)pressAddHourBtn:(id)sender;
-(IBAction)pressSubmitBtn:(id)sender;
-(IBAction)pressChooseRecipientBtn:(id)sender;
-(IBAction)pressChooseCategoryBtn:(id)sender;

-(IBAction)satisfactionSwitchPressed:(id)sender;
-(IBAction)referenceSwitchPressed:(id)sender;

@end

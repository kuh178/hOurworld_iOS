//
//  MTBReportHoursViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/14/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBItem.h"
#import "TDDatePickerController.h"
#import "GAITrackedViewController.h"

@interface MTBReportHoursViewController : GAITrackedViewController <UITextViewDelegate> {
    IBOutlet UITextView *note;
    IBOutlet UIButton *addDateBtn;
    IBOutlet UIButton *addHourBtn;
    IBOutlet UIButton *chooseRecipientBtn;
    IBOutlet UIBarButtonItem *submitBtn;
    
    IBOutlet UILabel *satisfactionLabel;
    IBOutlet UILabel *referenceLabel;
    
    //IBOutlet UISwitch *satisfactionSwitch;
    //IBOutlet UISwitch *referenceSwitch;
    IBOutlet UISegmentedControl *satisfactionSwitch;
    IBOutlet UISegmentedControl *referenceSwitch;
    
    NSString *isProvider;
    NSString *isReceiver;
    MTBItem *mItem;
    
    TDDatePickerController* setDatePickerView;
    
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
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;

@property (nonatomic, retain) IBOutlet UILabel *satisfactionLabel;
@property (nonatomic, retain) IBOutlet UILabel *referenceLabel;

//@property (nonatomic, retain) IBOutlet UISwitch *satisfactionSwitch;
//@property (nonatomic, retain) IBOutlet UISwitch *referenceSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *satisfactionSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *referenceSwitch;


@property (nonatomic, retain) NSString *isProvider;
@property (nonatomic, retain) NSString *isReceiver;
@property (nonatomic, retain) MTBItem *mItem;
@property (nonatomic, retain) TDDatePickerController* setDatePickerView;

//-(IBAction)satisfactionSwitch:(id)sender;
//-(IBAction)referenceSwitch:(id)sender;

-(IBAction)pressAddDateBtn:(id)sender;
-(IBAction)pressAddHourBtn:(id)sender;
-(IBAction)pressSubmitBtn:(id)sender;

-(IBAction)satisfactionSwitchPressed:(id)sender;
-(IBAction)referenceSwitchPressed:(id)sender;

@end

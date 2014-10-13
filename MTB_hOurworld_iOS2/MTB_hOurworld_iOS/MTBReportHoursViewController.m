//
//  MTBReportHoursViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/14/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBReportHoursViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTBItem.h"
#import "JSON.h"
#import "TDSemiModal.h"
#import "TDDatePickerController.h"

@interface MTBReportHoursViewController ()

@end

@implementation MTBReportHoursViewController

@synthesize note, addDateBtn, addHourBtn, chooseRecipientBtn, submitBtn, isProvider, isReceiver, mItem, setDatePickerView;
@synthesize satisfactionLabel, referenceLabel, satisfactionSwitch, referenceSwitch;

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
    // set delegate to note
    //note.delegate = self;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    NSLog(@"%d", mItem.mSvcCatID);
    NSLog(@"%d", mItem.mSvcID);
    
    // rounded corner
    addDateBtn.layer.cornerRadius = 5;
    addDateBtn.clipsToBounds = YES;
    
    addHourBtn.layer.cornerRadius = 5;
    addHourBtn.clipsToBounds = YES;
    
    chooseRecipientBtn.layer.cornerRadius = 5;
    chooseRecipientBtn.clipsToBounds = YES;
    
    // add borderline
    note.layer.borderColor = [[UIColor blackColor] CGColor];
    note.layer.borderWidth = 1.0f;
    
    // add a placeholder
    note.text = @"About recipient’s comments about promptness, quality, difficulty, etc. of the task";
    note.textColor = [UIColor lightGrayColor];
    
    // initialize "satisfaction" and "reference" to "T"
    satisfaction = @"T";
    reference = @"T";
    
    addDate = false;
    addHour = false;
    
    // initialize datepicker view
    setDatePickerView = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
    setDatePickerView.delegate = self;
    setDatePickerView.datePicker.backgroundColor = [UIColor whiteColor];
    
    if ([isReceiver isEqualToString:@"F"]) {
        [satisfactionLabel setHidden:YES];
        [satisfactionSwitch setHidden:YES];
        [referenceLabel setHidden:YES];
        [referenceSwitch setHidden:YES];
    }
    else {
        [satisfactionLabel setHidden:NO];
        [satisfactionSwitch setHidden:NO];
        [referenceLabel setHidden:NO];
        [referenceSwitch setHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ReportHoursViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)pressAddDateBtn:(id)sender {
    
    flag = YES;
    
    setDatePickerView.datePicker.datePickerMode = UIDatePickerModeDate;
    setDatePickerView.datePicker.backgroundColor = [UIColor whiteColor];
    
    [self presentSemiModalViewController:setDatePickerView];
}

-(IBAction)pressAddHourBtn:(id)sender {
    
    flag = NO;
    
    countDownDuration = 0.0;
    
    setDatePickerView.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    setDatePickerView.datePicker.minuteInterval = 15;
    setDatePickerView.datePicker.backgroundColor = [UIColor whiteColor];
    
    [self presentSemiModalViewController:setDatePickerView];
}

-(IBAction)pressSubmitBtn:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                message:@"Report hours?"
                                                delegate:self
                                                cancelButtonTitle:@"Report"
                                                otherButtonTitles:@"Cancel", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Report"]) {
        
        // check the fields first
        if (addDate != true || addHour != true) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Please fill out all fields"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil, nil];
            [message show];
        }
        else {
            // start downloading
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            NSDictionary *params;
            
            if([isProvider isEqualToString:@"T"]) {
                
                params = @{@"requestType"     :@"RecordHrs,0",
                           @"accessToken"     :[userDefault objectForKey:@"access_token"],
                           @"EID"             :[userDefault objectForKey:@"EID"],
                           @"memID"           :[userDefault objectForKey:@"memID"],
                           @"transDate"       :[NSString stringWithFormat:@"%@", date],
                           @"TDs"             :[NSString stringWithFormat:@"%@", hour],
                           @"transOrigin"     :[NSString stringWithFormat:@"M"],
                           @"transHappy"      :[NSString stringWithFormat:@"%@", satisfaction],
                           @"transRefer"      :[NSString stringWithFormat:@"%@", reference],
                           @"transNote"       :[NSString stringWithFormat:@"%@", note.text],
                           @"Provider"        :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"memID"]],
                           @"Receiver"        :[NSString stringWithFormat:@"%d", mItem.mListMbrID],
                           @"SvcCatID"        :[NSString stringWithFormat:@"%d", mItem.mSvcCatID],
                           @"SvcID"           :[NSString stringWithFormat:@"%d", mItem.mSvcID]};
                
            }
            else {
                params = @{@"requestType"     :@"RecordHrs,0",
                           @"accessToken"     :[userDefault objectForKey:@"access_token"],
                           @"EID"             :[userDefault objectForKey:@"EID"],
                           @"memID"           :[userDefault objectForKey:@"memID"],
                           @"transDate"       :[NSString stringWithFormat:@"%@", date],
                           @"TDs"             :[NSString stringWithFormat:@"%@", hour],
                           @"transOrigin"     :[NSString stringWithFormat:@"M"],
                           @"transHappy"      :[NSString stringWithFormat:@"%@", satisfaction],
                           @"transRefer"      :[NSString stringWithFormat:@"%@", reference],
                           @"transNote"       :[NSString stringWithFormat:@"%@", note.text],
                           @"Provider"        :[NSString stringWithFormat:@"%d", mItem.mListMbrID],
                           @"Receiver"        :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"memID"]],
                           @"SvcCatID"        :[NSString stringWithFormat:@"%d", mItem.mSvcCatID],
                           @"SvcID"           :[NSString stringWithFormat:@"%d", mItem.mSvcID]};
            }
            
            [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                      if([responseObject objectForKey:@"success"]) {
                          NSLog(@"Complete reporting hour");
                          
                          UIAlertView *dialog = [[UIAlertView alloc]init];
                          [dialog setDelegate:self];
                          [dialog setTitle:@"Message"];
                          [dialog setMessage:@"Your hour has been reported"];
                          [dialog addButtonWithTitle:@"Close"];
                          [dialog show];
                          
                          NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                          [userDefault setInteger:1 forKey:@"reload"];
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      else {
                          NSLog(@"Fail to report hour");
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", operation);
                  }];
        }
    }    
}

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
    // date
    if(flag) {
        NSDate *completedDate = viewController.datePicker.date;
        date = [dateFormatter stringFromDate:completedDate];
        
        [addDateBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
        
        addDate = true;
        
        [self dismissSemiModalViewController:setDatePickerView];

    }
    // hour
    else {
        countDownDuration = viewController.datePicker.countDownDuration;
    
        countDownDuration = (int)(countDownDuration / 60);
        
        if(countDownDuration == 0.0) {
            
        }
        else {
            
            NSString *hourString = [NSString stringWithFormat:@"%4.0f mins", countDownDuration];
            hourString = [hourString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [addHourBtn setTitle:hourString forState:UIControlStateNormal];
            
            if ([hourString isEqualToString:@"15 mins"]) {
                hour = @"0.15";
            }
            else if ([hourString isEqualToString:@"30 mins"]) {
                hour = @"0.30";
            }
            else if ([hourString isEqualToString:@"45 mins"]) {
                hour = @"0.45";
            }
            else if ([hourString isEqualToString:@"60 mins"]) {
                hour = @"1.00";
            }
            else if ([hourString isEqualToString:@"75 mins"]) {
                hour = @"1.15";
            }
            else if ([hourString isEqualToString:@"90 mins"]) {
                hour = @"1.30";
            }
            else if ([hourString isEqualToString:@"105 mins"]) {
                hour = @"1.45";
            }
            else if ([hourString isEqualToString:@"120 mins"]) {
                hour = @"2.00";
            }
            else if ([hourString isEqualToString:@"135 mins"]) {
                hour = @"2.15";
            }
            else if ([hourString isEqualToString:@"150 mins"]) {
                hour = @"2.30";
            }
            else if ([hourString isEqualToString:@"165 mins"]) {
                hour = @"2.45";
            }
            else if ([hourString isEqualToString:@"180 mins"]) {
                hour = @"3.00";
            }
            else if ([hourString isEqualToString:@"195 mins"]) {
                hour = @"3.15";
            }
            else if ([hourString isEqualToString:@"210 mins"]) {
                hour = @"3.30";
            }
            else if ([hourString isEqualToString:@"225 mins"]) {
                hour = @"3.45";
            }
            else if ([hourString isEqualToString:@"240 mins"]) {
                hour = @"4.00";
            }
            else if ([hourString isEqualToString:@"255 mins"]) {
                hour = @"4.15";
            }
            else if ([hourString isEqualToString:@"270 mins"]) {
                hour = @"4.30";
            }
            else if ([hourString isEqualToString:@"285 mins"]) {
                hour = @"4.45";
            }
            else if ([hourString isEqualToString:@"300 mins"]) {
                hour = @"5.00";
            }
            
            addHour = true;
            
            [self dismissSemiModalViewController:setDatePickerView];
        }
    }
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
    
	[self dismissSemiModalViewController:setDatePickerView];
}


- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [note endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"About recipient’s comments about promptness, quality, difficulty, etc. of the task"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Report hours";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //self.navigationController.navigationBar.backItem.title = @"Back";
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

-(IBAction)satisfactionSwitchPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        satisfaction = @"T";
    }
    else{
        satisfaction = @"F";
    }
}

-(IBAction)referenceSwitchPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        reference = @"T";
    }
    else{
        reference = @"F";
    }
}

@end

//
//  MTBReportHourFromMainViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBReportHourFromMainViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTBItem.h"
#import "JSON.h"
#import "MTBReportHourTaskCategoryViewController.h"

@interface MTBReportHourFromMainViewController ()

@end

@implementation MTBReportHourFromMainViewController

@synthesize note, addDateBtn, addHourBtn, chooseRecipientBtn, chooseCategoryBtn, submitBtn, isProvider, isReceiver;
@synthesize satisfactionLabel, referenceLabel, satisfactionSwitch, referenceSwitch;

NSString *mListMemName;
int mListMemID = 0;
int mSvcCatID = 0;
int mSvcID = 0;

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
    
    // rounded corner
    addDateBtn.layer.cornerRadius = 5;
    addDateBtn.clipsToBounds = YES;
    
    addHourBtn.layer.cornerRadius = 5;
    addHourBtn.clipsToBounds = YES;
    
    chooseRecipientBtn.layer.cornerRadius = 5;
    chooseRecipientBtn.clipsToBounds = YES;
    
    chooseCategoryBtn.layer.cornerRadius = 5;
    chooseCategoryBtn.clipsToBounds = YES;
    
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
    
    [ActionSheetDatePicker showPickerWithTitle:@"Select Date"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:[NSDate date]
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         
                                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                         
                                         NSDate *completedDate = selectedDate;
                                         date = [dateFormatter stringFromDate:completedDate];
                                         
                                         [addDateBtn setTitle:[NSString stringWithFormat:@"%@", date] forState:UIControlStateNormal];
                                         
                                         addDate = true;
                                         
                                     }
                                   cancelBlock:^(ActionSheetDatePicker *picker) {
                                       
                                   }
                                    origin:sender];
}


-(IBAction)pressAddHourBtn:(id)sender {
    
    NSArray *hourArray = [NSArray arrayWithObjects:
                          @"15 mins", @"30 mins", @"45 mins", @"60 mins",
                          @"75 mins", @"90 mins", @"105 mins", @"120 mins",
                          @"135 mins", @"150 mins", @"165 mins", @"180 mins",
                          @"195 mins", @"210 mins", @"225 mins", @"240 mins",
                          @"255 mins", @"270 mins", @"285 mins", @"300 mins", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Hours"
                                            rows:hourArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           NSString *hourString = [NSString stringWithFormat:@"%@", selectedValue];
                                           [addHourBtn setTitle:hourString forState:UIControlStateNormal];
                                           
                                           if ([hourString isEqualToString:@"15 mins"]) {
                                               hour = @"0.25";
                                           }
                                           else if ([hourString isEqualToString:@"30 mins"]) {
                                               hour = @"0.50";
                                           }
                                           else if ([hourString isEqualToString:@"45 mins"]) {
                                               hour = @"0.75";
                                           }
                                           else if ([hourString isEqualToString:@"60 mins"]) {
                                               hour = @"1.00";
                                           }
                                           else if ([hourString isEqualToString:@"75 mins"]) {
                                               hour = @"1.25";
                                           }
                                           else if ([hourString isEqualToString:@"90 mins"]) {
                                               hour = @"1.50";
                                           }
                                           else if ([hourString isEqualToString:@"105 mins"]) {
                                               hour = @"1.75";
                                           }
                                           else if ([hourString isEqualToString:@"120 mins"]) {
                                               hour = @"2.00";
                                           }
                                           else if ([hourString isEqualToString:@"135 mins"]) {
                                               hour = @"2.25";
                                           }
                                           else if ([hourString isEqualToString:@"150 mins"]) {
                                               hour = @"2.50";
                                           }
                                           else if ([hourString isEqualToString:@"165 mins"]) {
                                               hour = @"2.75";
                                           }
                                           else if ([hourString isEqualToString:@"180 mins"]) {
                                               hour = @"3.00";
                                           }
                                           else if ([hourString isEqualToString:@"195 mins"]) {
                                               hour = @"3.25";
                                           }
                                           else if ([hourString isEqualToString:@"210 mins"]) {
                                               hour = @"3.50";
                                           }
                                           else if ([hourString isEqualToString:@"225 mins"]) {
                                               hour = @"3.75";
                                           }
                                           else if ([hourString isEqualToString:@"240 mins"]) {
                                               hour = @"4.00";
                                           }
                                           else if ([hourString isEqualToString:@"255 mins"]) {
                                               hour = @"4.25";
                                           }
                                           else if ([hourString isEqualToString:@"270 mins"]) {
                                               hour = @"4.50";
                                           }
                                           else if ([hourString isEqualToString:@"285 mins"]) {
                                               hour = @"4.75";
                                           }
                                           else if ([hourString isEqualToString:@"300 mins"]) {
                                               hour = @"5.00";
                                           }
                                           
                                           addHour = true;
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Report"]) {
        
        NSLog(@"%@ %@", hour, date);
        
        // check the fields first
        if (addDate != true || addHour != true || mListMemID == 0 || mSvcCatID == 0 || mSvcID == 0) {
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
                           @"Receiver"        :[NSString stringWithFormat:@"%d", mListMemID],
                           @"SvcCatID"        :[NSString stringWithFormat:@"%d", mSvcCatID],
                           @"SvcID"           :[NSString stringWithFormat:@"%d", mSvcID]};
                
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
                           @"Provider"        :[NSString stringWithFormat:@"%d", mListMemID],
                           @"Receiver"        :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"memID"]],
                           @"SvcCatID"        :[NSString stringWithFormat:@"%d", mSvcCatID],
                           @"SvcID"           :[NSString stringWithFormat:@"%d", mSvcID]};
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

-(IBAction)pressChooseRecipientBtn:(id)sender {
    MTBChooseMemberViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBChooseMemberViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addItemViewController:(MTBChooseMemberViewController *)controller didFinishEnteringItem:(NSDictionary *)item {
    
    mListMemID = [[item objectForKey:@"MbrID"] intValue];
    mListMemName = [NSString stringWithFormat:@"%@ %@", [[item objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [[item objectForKey:@"Lname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    [chooseRecipientBtn setTitle:[NSString stringWithFormat:@"Member: %@ %@", [[item objectForKey:@"Fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [[item objectForKey:@"Lname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] forState:UIControlStateNormal];
    
    NSLog(@"%d %d %@", [[item objectForKey:@"MbrID"] intValue], mListMemID, mListMemName);
}

-(IBAction)pressChooseCategoryBtn:(id)sender {
    MTBReportHourTaskCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHourTaskCategoryViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addCategoryViewController:(MTBReportHourTaskCategoryViewController *)controller didFinishEnteringItem:(NSString *)SvcCat SvcCatID:(int)pSvcCatID Service:(NSString *)pService SvcID:(int)pSvcID {
    
    NSLog(@"mSvcCatID: %d, mSvcCatID: %d", pSvcCatID, pSvcID);
    NSLog(@"%@ %@", SvcCat, pService);
    
    mSvcCatID = pSvcCatID;
    mSvcID = pSvcID;
    
    NSLog(@"%d %d", pSvcCatID, pSvcID);
    
    [chooseCategoryBtn setTitle:[NSString stringWithFormat:@"%@ > %@", SvcCat, pService] forState:UIControlStateNormal];
}

-(IBAction)pressSubmitBtn:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Report hours?"
                                                     delegate:self
                                            cancelButtonTitle:@"Report"
                                            otherButtonTitles:@"Cancel", nil];
    [message show];
}

@end

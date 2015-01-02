//
//  MainPageViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 1/21/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainPageViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate>{
    IBOutlet UIButton *announcementBtn;
    IBOutlet UIButton *reportHoursBtn;
    IBOutlet UIButton *infoBtn;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *locationLabel;
    
}

@property (nonatomic, retain) IBOutlet UIButton *announcementBtn;
@property (nonatomic, retain) IBOutlet UIButton *reportHoursBtn;
@property (nonatomic, retain) IBOutlet UIButton *infoBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

-(IBAction)announcementBtnPressed:(id)sender;
-(IBAction)reportHoursBtnPressed:(id)sender;
-(IBAction)infoBtnPressed:(id)sender;
@end

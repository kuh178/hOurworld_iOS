//
//  MTBMoreViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import <MessageUI/MessageUI.h>

@interface MTBMoreViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate>{
    IBOutlet UIButton *profileBtn;
    IBOutlet UIButton *aboutBtn;
    IBOutlet UIButton *aboutAppBtn;
    IBOutlet UIButton *shareBtn;
    IBOutlet UIButton *updateBtn;
    IBOutlet UIButton *logoutBtn;
    
    IBOutlet UIImageView *exclamationImage;
}

@property (nonatomic, retain) IBOutlet UIButton *profileBtn;
@property (nonatomic, retain) IBOutlet UIButton *aboutBtn;
@property (nonatomic, retain) IBOutlet UIButton *aboutAppBtn;
@property (nonatomic, retain) IBOutlet UIButton *shareBtn;
@property (nonatomic, retain) IBOutlet UIButton *updateBtn;
@property (nonatomic, retain) IBOutlet UIButton *logoutBtn;
@property (nonatomic, retain) IBOutlet UIImageView *exclamationImage;

-(IBAction)profileBtnClicked:(id)sender;
-(IBAction)aboutBtnClicked:(id)sender;
-(IBAction)aboutAppBtnClicked:(id)sender;
-(IBAction)shareAppBtnClicked:(id)sender;
-(IBAction)updateBtnClicked:(id)sender;
-(IBAction)logoutBtnClicked:(id)sender;

@end

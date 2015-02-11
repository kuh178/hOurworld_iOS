//
//  MTBProfilePrivateEmailViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 2/9/15.
//  Copyright (c) 2015 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBProfilePrivateEmailViewController : GAITrackedViewController <UIScrollViewDelegate> {
    IBOutlet UIBarButtonItem *sendEmailBtn;
    IBOutlet UITextField *subject;
    IBOutlet UITextField *emailDescription;
    
    int profileUserID;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendEmailBtn;
@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextField *emailDescription;
@property (nonatomic, assign) int profileUserID;

-(IBAction)sendEmailBtnPressed:(id)sender;

@end

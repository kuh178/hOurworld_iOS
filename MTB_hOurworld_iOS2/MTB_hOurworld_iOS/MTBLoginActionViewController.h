//
//  MTBLoginActionViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBLoginActionViewController : GAITrackedViewController {
    IBOutlet UITextField *accountTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *sendMessageBtn;
}

@property (nonatomic, retain) IBOutlet UITextField *accountTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton *sendMessageBtn;

- (IBAction)loginBtnPressed:(id)sender;

@end

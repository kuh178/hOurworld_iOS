//
//  LoginViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBLoginViewController : GAITrackedViewController {
    IBOutlet UIButton *registerBtn;
    IBOutlet UIButton *loginBtn;
}

@property (nonatomic, retain) IBOutlet UIButton *registerBtn;
@property (nonatomic, retain) IBOutlet UIButton *loginBtn;

- (IBAction)registerBtnPressed:(id)sender;
- (IBAction)loginBtnPressed:(id)sender;

@end

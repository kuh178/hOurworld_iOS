//
//  MTBAddGroupMessageViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBAddGroupMessageViewController : UIViewController {
    IBOutlet UITextField *message;
    IBOutlet UIBarButtonItem *submitBtn;
    
    int groupID;
}

@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;

@property (nonatomic, assign) int groupID;

-(IBAction)pressSubmitBtn:(id)sender;

@end

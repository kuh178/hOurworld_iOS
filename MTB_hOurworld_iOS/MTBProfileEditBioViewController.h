//
//  MTBProfileEditBioViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/18/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBProfileEditBioViewController : UIViewController {
    NSString *bioDescription;
    IBOutlet UIBarButtonItem *doneBtn;
    IBOutlet UITextView *bioTextView;
}

@property (nonatomic, retain) NSString *bioDescription;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;

-(IBAction)pressDoneBtn:(id)sender;

@end

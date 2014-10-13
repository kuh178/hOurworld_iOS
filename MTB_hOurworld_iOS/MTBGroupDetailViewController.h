//
//  MTBGroupDetailViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBGroupDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSString *groupName;
    NSString *groupDescription;
    NSInteger groupID;

    NSMutableArray *jsonArray;
    IBOutlet UILabel *groupNameLabel;
    IBOutlet UITableView *tableViewList;
    IBOutlet UILabel *groupMembersNumLabel;
    
    IBOutlet UIBarButtonItem *leaveGroupBtn;
    IBOutlet UIBarButtonItem *joinGroupBtn;
    
    bool isMember;
}

@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *groupDescription;
@property (nonatomic, assign) NSInteger groupID;

@property (nonatomic, retain) NSMutableArray *jsonArray;

@property (nonatomic, retain) IBOutlet UILabel *groupNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *groupMembersNumLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *leaveGroupBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *joinGroupBtn;

-(IBAction)leaveGroupBtnClicked:(id)sender;
-(IBAction)joinGroupBtnClicked:(id)sender;

@end

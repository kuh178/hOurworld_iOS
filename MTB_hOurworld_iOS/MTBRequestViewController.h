//
//  MTBRequestViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "DropDownListView.h"

@interface MTBRequestViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, kDropDownListViewDelegate> {
    NSMutableArray *scheduleList;
    NSMutableArray *jsonArray;
    NSMutableArray *scheduleListCopy;
    
    IBOutlet UITableView *tableViewList;
    IBOutlet UIBarButtonItem *refreshBtn;
    IBOutlet UIBarButtonItem *addBtn;
    IBOutlet UIBarButtonItem *searchBtn;
    
    DropDownListView *Dropobj;
    
    NSMutableArray *categoryList;
}

@property (nonatomic, retain) NSMutableArray *scheduleList;
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *searchBtn;

- (IBAction)pressRefreshBtn:(id)sender;
- (IBAction)pressAddBtn:(id)sender;
- (IBAction)pressSearchBtn:(id)sender;
- (void)updateTimeLine;

@end

//
//  FirstViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBFinalTaskPostViewController.h"
#import "GAITrackedViewController.h"

@interface FirstViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
	NSMutableArray *scheduleList;
    NSMutableArray *jsonArray;
    
    IBOutlet UITableView *tableViewList;
    IBOutlet UIBarButtonItem *refreshBtn;
    IBOutlet UIBarButtonItem *addBtn;
}

@property (nonatomic, retain) NSMutableArray *scheduleList;
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addBtn;

- (IBAction)pressRefreshBtn:(id)sender;
- (IBAction)pressAddBtn:(id)sender;


@end

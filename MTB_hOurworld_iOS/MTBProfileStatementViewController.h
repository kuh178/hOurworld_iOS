//
//  MTBProfileStatementViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 2/4/15.
//  Copyright (c) 2015 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBProfileStatementViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *statementArray;
    IBOutlet UITableView *tableViewList;
}

@property (nonatomic, retain) NSMutableArray *statementArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;

@end

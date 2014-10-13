//
//  MTBOffersRequestsViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 4/24/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBOffersRequestsViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *list;
    IBOutlet UITableView *tableViewList;
}

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;

@end

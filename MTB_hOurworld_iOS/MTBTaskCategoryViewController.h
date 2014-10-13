//
//  MTBTaskCategoryViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/17/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBTaskCategoryViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
	NSMutableArray *scheduleList;
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
    IBOutlet UILabel *stepLabel;
    
    NSString *isOffer;
    NSString *isRequest;
}

@property (nonatomic, retain) NSMutableArray *scheduleList;
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UILabel *stepLabel;

@property (nonatomic, retain) NSString *isOffer;
@property (nonatomic, retain) NSString *isRequest;

- (void)updateTimeLine;

@end


//
//  MTBCategoryViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBCategoryViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
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


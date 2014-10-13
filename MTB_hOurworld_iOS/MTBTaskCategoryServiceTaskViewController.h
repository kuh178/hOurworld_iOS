//
//  MTBTaskCategoryServiceTaskViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/17/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBTaskCategoryServiceTaskViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *scheduleList;
    NSMutableArray *scheduleListCopy;
    NSMutableArray *jsonArray;
    
    IBOutlet UITableView *tableViewList;
    
    NSString *svcCat;
    NSInteger svcCatID;
    NSString *service;
    NSInteger svcID;
    NSString *isOffer;
    NSString *isRequest;
    
    NSMutableArray *categoryList;
}

@property (nonatomic, retain) NSMutableArray *scheduleList;
@property (nonatomic, retain) NSMutableArray *scheduleListCopy;
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;

@property (nonatomic, retain) NSString *svcCat;
@property (nonatomic, assign) NSInteger svcCatID;
@property (nonatomic, retain) NSString *service;
@property (nonatomic, assign) NSInteger svcID;
@property (nonatomic, retain) NSString *isOffer;
@property (nonatomic, retain) NSString *isRequest;


@end

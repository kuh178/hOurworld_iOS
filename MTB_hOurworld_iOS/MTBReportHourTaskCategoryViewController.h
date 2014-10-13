//
//  MTBReportHourTaskCategoryViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "MTBReportHourTaskCategoryServiceViewController.h"

@protocol MTBReportHourTaskCategoryViewControllerDelegate <NSObject>
- (void)addCategoryViewController:(id)controller didFinishEnteringItem:(NSString *)SvcCat SvcCatID:(int)pSvcCatID Service:(NSString *)pService SvcID:(int)pSvcID;
@end
@interface MTBReportHourTaskCategoryViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, MTBReportHourTaskCategoryServiceViewControllerDelegate> {
    
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, weak) id <MTBReportHourTaskCategoryViewControllerDelegate> delegate;

- (void)updateTimeLine;

@end

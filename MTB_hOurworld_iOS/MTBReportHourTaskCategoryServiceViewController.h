//
//  MTBReportHourTaskCategoryServiceViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol MTBReportHourTaskCategoryServiceViewControllerDelegate <NSObject>
- (void)addServiceViewController:(id)controller didFinishEnteringItem:(NSString *)SvcCat SvcCatID:(int)pSvcCatID Service:(NSString *)pService SvcID:(int)pSvcID;
@end
@interface MTBReportHourTaskCategoryServiceViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
    
    NSString *svcCat;
    NSInteger svcCatID;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;

@property (nonatomic, retain) NSString *svcCat;
@property (nonatomic, assign) NSInteger svcCatID;

@property (nonatomic, weak) id <MTBReportHourTaskCategoryServiceViewControllerDelegate> delegate;

@end



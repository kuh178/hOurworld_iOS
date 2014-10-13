//
//  MTBGroupMessageViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBGroupMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
    
    int groupID;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) int groupID;

@end

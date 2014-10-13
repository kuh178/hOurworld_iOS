//
//  MTBGroupSearchViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBGroupSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;

@end

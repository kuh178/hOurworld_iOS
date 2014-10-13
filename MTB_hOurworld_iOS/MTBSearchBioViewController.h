//
//  MTBSearchBioViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/3/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBSearchBioViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *searchType;
    NSString *searchTerm;
    
    NSMutableArray *jsonArray;
    IBOutlet UITableView *tableViewList;
    
}

@property (nonatomic, retain) NSString *searchType;
@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;


@end

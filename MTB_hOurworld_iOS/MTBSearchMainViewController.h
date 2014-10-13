//
//  MTBSearchMainViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MTBSearchMainViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSString *searchTerm;
    
    NSMutableArray *jsonArray;
    NSMutableArray *outputArray;
    IBOutlet UITableView *tableViewList;
    IBOutlet UITextField *searchBar;
    IBOutlet UIButton *searchBtn;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) NSMutableArray *outputArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UITextField *searchBar;
@property (nonatomic, retain) IBOutlet UIButton *searchBtn;

-(IBAction)pressSearchBtn:(id)sender;

@end


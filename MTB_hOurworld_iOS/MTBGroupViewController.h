//
//  MTBGroupViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/29/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *jsonArray;
    
    IBOutlet UITableView *tableViewList;
    IBOutlet UIBarButtonItem *searchGroupBtn;
    IBOutlet UIBarButtonItem *messageGroupBtn;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *searchGroupBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *messageGroupBtn;

- (IBAction)pressSearchGropupBtn:(id)sender;
- (IBAction)pressMessageGroupBtn:(id)sender;


@end

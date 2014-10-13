//
//  MTBChooseMemberViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 10/9/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@protocol MTBChooseMemberViewControllerDelegate <NSObject>
- (void)addItemViewController:(id)controller didFinishEnteringItem:(NSDictionary *)item;
@end

@interface MTBChooseMemberViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate> {
    NSMutableArray *jsonArray;
    NSMutableArray *searchResult;
    IBOutlet UITableView *tableViewList;
    IBOutlet UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, retain) IBOutlet UITableView *tableViewList;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

@property (nonatomic, weak) id <MTBChooseMemberViewControllerDelegate> delegate;

@end

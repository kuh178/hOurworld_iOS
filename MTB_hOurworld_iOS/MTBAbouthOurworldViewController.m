//
//  MTBAbouthOurworldViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/6/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBAbouthOurworldViewController.h"

@interface MTBAbouthOurworldViewController ()

@end

@implementation MTBAbouthOurworldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AboutPageViewController";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"About hOurworld";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [super viewWillAppear:animated];
}

@end

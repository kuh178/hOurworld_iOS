//
//  MTBInfoViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBInfoViewController.h"

@interface MTBInfoViewController ()

@end

@implementation MTBInfoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"hOurworld_mobile_app", nil)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Back", nil)] style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

@end

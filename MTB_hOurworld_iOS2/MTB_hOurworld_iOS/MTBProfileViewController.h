//
//  MTBProfileViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/14/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "GAITrackedViewController.h"

@interface MTBProfileViewController : GAITrackedViewController <UIScrollViewDelegate, CustomIOS7AlertViewDelegate> {
    int memID;
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *summaryLabel;
    IBOutlet UILabel *bioLabel;
    IBOutlet UITextView *contactInfo;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UILabel *offersLabel;
    IBOutlet UILabel *offersTitleLabel;
    IBOutlet UIImageView *offersLine;

    IBOutlet UILabel *requestsLabel;
    IBOutlet UILabel *requestsTitleLabel;
    IBOutlet UIImageView *requestsLine;
    
    IBOutlet UIButton *reportHourBtn;
    IBOutlet UIButton *creditHistoryBtn;
    IBOutlet UIBarButtonItem *logoutBtn;
    
    IBOutlet UILabel *shareMyLocLabel;
    IBOutlet UISwitch *shareMyLocSwitch;
    
    IBOutlet UIButton *editContact;
    IBOutlet UIButton *editBio;
    
    IBOutlet UIImageView *badgeImageView1;
    IBOutlet UIImageView *badgeImageView2;
    IBOutlet UIImageView *badgeImageView3;
    IBOutlet UIImageView *badgeImageView4;
    IBOutlet UIImageView *badgeImageView5;
    IBOutlet UIImageView *badgeImageView6;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NSString *username;
    NSString *profileImage;
    NSString *city;
    NSString *bio;
    NSString *contact;
    
    NSString *home1;
    NSString *email1;
    NSString *mobile;
    NSString *website;
    
    NSString *totalServices;
    NSString *totalReceives;
    NSString *totalExcHours;
    NSString *totalRefs;
    NSString *totalGroups;
    NSString *diversity;
    NSString *pageVisits;
    NSString *consecMo;
    NSString *orientation;
    NSString *profileImageDone;
    NSString *advTraining;
    
    NSString *totalServicesTitle;
    NSString *totalReceivesTitle;
    NSString *totalExcHoursTitle;
    NSString *totalRefsTitle;
    NSString *totalGroupsTitle;
    NSString *diversityTitle;
    NSString *pageVisitsTitle;
    NSString *consecMoTitle;
    NSString *orientationTitle;
    NSString *profileImageDoneTitle;
    NSString *advTrainingTitle;
    
    int totalTrans;
    int totalMbrs;
    int revCount;
    int satPct;
    
    int height;
}

@property (nonatomic, assign) int memID;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *summaryLabel;
@property (nonatomic, retain) IBOutlet UILabel *bioLabel;
@property (nonatomic, retain) IBOutlet UITextView *contactInfo;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UILabel *offersLabel;
@property (nonatomic, retain) IBOutlet UILabel *offersTitleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *offersLine;

@property (nonatomic, retain) IBOutlet UILabel *requestsLabel;
@property (nonatomic, retain) IBOutlet UILabel *requestsTitleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *requestsLine;

@property (nonatomic, retain) IBOutlet UIButton *reportHourBtn;
@property (nonatomic, retain) IBOutlet UIButton *creditHistoryBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *logoutBtn;

@property (nonatomic, retain) IBOutlet UILabel *shareMyLocLabel;
@property (nonatomic, retain) IBOutlet UISwitch *shareMyLocSwitch;

@property (nonatomic, retain) IBOutlet UIButton *editContact;
@property (nonatomic, retain) IBOutlet UIButton *editBio;

@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView1;
@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView2;
@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView3;
@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView4;
@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView5;
@property (nonatomic, retain) IBOutlet UIImageView *badgeImageView6;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)pressReportHourBtn:(id)sender;
-(IBAction)pressCreditHistoryBtn:(id)sender;
-(IBAction)pressLogoutBtn:(id)sender;
-(IBAction)toggleSwitch:(id)sender;

@end

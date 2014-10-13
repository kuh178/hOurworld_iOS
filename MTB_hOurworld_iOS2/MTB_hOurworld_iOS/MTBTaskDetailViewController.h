//
//  MTBTaskDetailViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/13/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBItem.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAnnotation.h"
#import "TSAlertView.h"
#import "GAITrackedViewController.h"
#import <MessageUI/MessageUI.h>

@interface MTBTaskDetailViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, TSAlertViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>{
    MTBItem *mItem;
    
    IBOutlet UIImageView *profileImage;
    IBOutlet UIBarButtonItem *reportHoursBtn;
    IBOutlet UIBarButtonItem *replyBtn;
    IBOutlet UIBarButtonItem *removeBtn;
    IBOutlet UIBarButtonItem *editBtn;
    IBOutlet UIButton *largeMapViewBtn;
    
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *locationLabel;
    IBOutlet UIButton *usernameBtn;
    IBOutlet UILabel *timestampLabel;
    IBOutlet UITextView *taskInfoTextView;
    IBOutlet UILabel *taskCategoryLabel;
    
    IBOutlet UIWebView *webView;
    
    IBOutlet UIScrollView *scrollView;
    
    NSString *mIsOffer;
}

@property (nonatomic, retain) MTBItem *mItem;

@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reportHoursBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *replyBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *removeBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editBtn;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *largeMapViewBtn;

@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIButton *usernameBtn;
@property (nonatomic, retain) IBOutlet UILabel *timestampLabel;
@property (nonatomic, retain) IBOutlet UITextView *taskInfoTextView;
@property (nonatomic, retain) IBOutlet UILabel *taskCategoryLabel;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSString *mIsOffer;

-(IBAction)pressReportHourBtn:(id)sender;
-(IBAction)pressReplyBtn:(id)sender;
-(IBAction)pressRemoveBtn:(id)sender;
-(IBAction)pressLargeMapViewBtn:(id)sender;

@end

//
//  MTBMessageDetailViewController.h
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

@interface MTBMessageDetailViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, TSAlertViewDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate>{
    MTBItem *mItem;
    
    IBOutlet UIImageView *profileImage;
    IBOutlet UIImageView *xDayImage;
    
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *locationLabel;
    IBOutlet UIButton *usernameBtn;
    IBOutlet UILabel *timestampLabel;
    IBOutlet UILabel *xDayLabel;
    IBOutlet UITextView *taskInfo;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *largeViewBtn;

    IBOutlet UIBarButtonItem *emailBtn;
    IBOutlet UIBarButtonItem *replyBarBtn;
    IBOutlet UIBarButtonItem *reportHourBarBtn;
    IBOutlet UIBarButtonItem *removeBarBtn;
    
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) MTBItem *mItem;

@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIImageView *xDayImage;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIButton *usernameBtn;
@property (nonatomic, retain) IBOutlet UILabel *timestampLabel;
@property (nonatomic, retain) IBOutlet UILabel *xDayLabel;
@property (nonatomic, retain) IBOutlet UITextView *taskInfo;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIButton *largeViewBtn;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *emailBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *replyBarBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reportHourBarBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *removeBarBtn;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

-(IBAction)pressReplyBtn:(id)sender;
-(IBAction)pressReportHourBtn:(id)sender;
-(IBAction)pressremoveBtn:(id)sender;
-(IBAction)pressLargeViewBtn:(id)sender;

-(IBAction)pressEmailBtn:(id)sender;

@end

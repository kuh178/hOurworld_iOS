//
//  MTBTaskEditViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/16/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"
#import "MTBAddPushpinViewController.h"
#import "GAITrackedViewController.h"
#import "MTBItem.h"

@interface MTBTaskEditViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, ViewControllerBDelegate> {
    
    IBOutlet UILabel *serviceLabel;
    
    IBOutlet UITextView *taskDescription;
    IBOutlet UIBarButtonItem *submitBtn;
    IBOutlet UIButton *mapBtn;
    
    IBOutlet MKMapView *mapView;
    
    LocationAnnotation *annotation;
    CLLocationManager *locationManager;
    
    NSInteger svcCatID;
    NSInteger svcID;
    NSString *svcCat;
    NSString *service;
    NSString *isOffer;
    NSString *isRequest;
    
    double oLat;
    double oLon;
    double dLat;
    double dLon;
    
    MTBItem *item;
}

@property (nonatomic, retain) IBOutlet UITextView *taskDescription;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;
@property (nonatomic, retain) IBOutlet UIButton *mapBtn;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) LocationAnnotation *annotation;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, assign) NSInteger svcCatID;
@property (nonatomic, assign) NSInteger svcID;
@property (nonatomic, retain) NSString *svcCat;
@property (nonatomic, retain) NSString *service;
@property (nonatomic, retain) NSString *isOffer;
@property (nonatomic, retain) NSString *isRequest;

@property (nonatomic, retain) MTBItem *item;

@property (nonatomic, retain) IBOutlet UILabel *serviceLabel;

-(IBAction)pressMapBtn:(id)sender;
-(IBAction)pressSubmitBtn:(id)sender;

@end

//
//  MTBFinalTaskPostViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"
#import "MTBAddPushpinViewController.h"
#import "GAITrackedViewController.h"
#import "MTBItem.h"

@interface MTBFinalTaskPostViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, ViewControllerBDelegate> {

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
    bool isEdit;
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
@property (nonatomic, assign) bool isEdit;

-(IBAction)pressMapBtn:(id)sender;
-(IBAction)pressSubmitBtn:(id)sender;

@end

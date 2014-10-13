//
//  MTBAddPushpinViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/4/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"
#import "GAITrackedViewController.h"


// http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers
@class MTBAddPushpinViewController;

@protocol ViewControllerBDelegate <NSObject>
- (void)addItemViewController:(MTBAddPushpinViewController *)controller oLatitude:(double)oLatitude oLongitude:(double)oLongitude dLatitude:(double)dLatitude dLongitude:(double)dLongitude;

@end

@interface MTBAddPushpinViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    IBOutlet UIBarButtonItem *submitBtn;
    
    IBOutlet MKMapView *mapView;
    
    LocationAnnotation *annotation;
    CLLocationManager *locationManager;
    
    double pickedoLat;
    double pickedoLon;
    double pickeddLat;
    double pickeddLon;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) LocationAnnotation *annotation;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, weak) id <ViewControllerBDelegate> delegate;

-(IBAction)pressSubmitBtn:(id)sender;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;


@end

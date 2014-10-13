//
//  MTBRegistrationMapViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"

@interface MTBRegistrationMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    IBOutlet MKMapView *mapView;
    
    LocationAnnotation *annotation;
    CLLocationManager *locationManager;
    
    double latitude;
    double longitude;
    
    NSMutableArray *jsonArray;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) LocationAnnotation *annotation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

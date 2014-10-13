//
//  LargeMapViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 9/23/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"

@interface LargeMapViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
	
	NSMutableArray *dataList;
	IBOutlet MKMapView *map;
	IBOutlet UISegmentedControl *mapType;
	double latitude;
	double longitude;
	
	LocationAnnotation *locationAnnotation;
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapType;
@property (nonatomic, retain) LocationAnnotation *locationAnnotation;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

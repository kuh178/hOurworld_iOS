//
//  LargeMapViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 9/23/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "LargeMapViewController.h"
#import "JSON.h"
#import "MTBItem.h"

@interface LargeMapViewController ()

@end

@implementation LargeMapViewController

@synthesize map;
@synthesize mapType;
@synthesize dataList;
@synthesize latitude, longitude;
@synthesize locationAnnotation, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    map.showsUserLocation = YES;
	map.mapType = MKMapTypeStandard;
	map.delegate = self;
	CLLocationCoordinate2D location;
	
	location.latitude = latitude;
    location.longitude = longitude;
    
    // convert unix timestamp to date format
    locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:location];
    [map addAnnotation:locationAnnotation];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 3000, 3000);
    
	[map setRegion:region animated:FALSE];
	[map regionThatFits:region];
    
	// initialize locationManager
	locationManager = [[CLLocationManager alloc] init];
	
	// assign this page as a delegate
	locationManager.delegate = self;
	
	// ask LocationManager to give accurate location info as much as possible.
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	
	// disable the 'Sleep mode'
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	// start tracking the path.
    // call didUpdateToLocation callback
	[locationManager startUpdatingLocation];
	
	//MKUserLocation *userLocation = map.userLocation;
	//CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
	
	[map setCenterCoordinate:location animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	// do something below here, if we need user location data.
    NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //[map setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"LargeMapViewController";
    
    [locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Task location"];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

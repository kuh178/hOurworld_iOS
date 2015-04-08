//
//  MTBAddPushpinViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/4/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBAddPushpinViewController.h"

@interface MTBAddPushpinViewController ()

@end

@implementation MTBAddPushpinViewController

@synthesize submitBtn, mapView, annotation, locationManager;

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
    
    [self setupMapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddPushPinViewController";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Add_location", nil)];
    [super viewWillAppear:animated];
}

- (void) setupMapView {
    
    // set latitude, longitude.
    pickedoLat = 0.0;
    pickedoLon = 0.0;
    pickeddLat = 0.0;
    pickeddLon = 0.0;
    
    // set annotation.
    annotation = [[LocationAnnotation alloc]init];
    
    mapView.showsUserLocation = YES;
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	CLLocationCoordinate2D location;
    
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 1;
	span.longitudeDelta = 1;
	
	region.span = span;
	region.center = location;
	
	[mapView setRegion:region animated:FALSE];
	[mapView regionThatFits:region];
    
	// initialize locationManager
	locationManager = [[CLLocationManager alloc] init];
	
	// assign this page as a delegate
	locationManager.delegate = self;
	
	// ask LocationManager to give accurate location info as much as possible.
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
    
	// disable the 'Sleep mode'
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // start tracking the path, call didUpdateToLocation callback
	[locationManager startUpdatingLocation];
	
	MKUserLocation *userLocation = mapView.userLocation;
	CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
	
	[mapView setCenterCoordinate:coordinate animated:YES];
    
    // add the recognizer to the map
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.7; //user needs to press for 0.7 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    pickedoLat = newLocation.coordinate.latitude;
    pickedoLon = newLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}

-(void)handleLongPress:(UITapGestureRecognizer *)tap{
    
    NSLog(@"TappedGesture");
    if (tap.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    // remove existing annotation first.
    [mapView removeAnnotation:annotation];
    
    // re-calculate annotation.
    CGPoint touchPoint = [tap locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    pickeddLat = touchMapCoordinate.latitude;
    pickeddLon = touchMapCoordinate.longitude;
    
    annotation = [[LocationAnnotation alloc]initWithCoordinate:touchMapCoordinate];
    [mapView addAnnotation:annotation];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    float prevPinchScale;
    
	prevPinchScale = 1.0;
    
    float thisScale = 1 + (pinch.scale - prevPinchScale);
    prevPinchScale = pinch.scale;
    self.view.transform = CGAffineTransformScale(self.view.transform, thisScale, thisScale);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pressSubmitBtn:(id)sender {
    [self.delegate addItemViewController:self oLatitude:pickedoLat oLongitude:pickedoLon dLatitude:pickeddLat dLongitude:pickeddLon];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

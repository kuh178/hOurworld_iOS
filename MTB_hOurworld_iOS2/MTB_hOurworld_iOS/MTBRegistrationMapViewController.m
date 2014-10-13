//
//  MTBRegistrationMapViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 7/2/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBRegistrationMapViewController.h"
#import "MTBRegisterationDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#define kOFFSET_FOR_KEYBOARD 80.0
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MTBRegistrationMapViewController ()

@end

@implementation MTBRegistrationMapViewController
@synthesize mapView, annotation, locationManager, latitude, longitude;

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
    
    
    
    [self downloadContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupMapView {
    
    // set latitude, longitude.
    latitude = 0.0;
    longitude = 0.0;
    
	// initialize locationManager
	locationManager = [[CLLocationManager alloc] init];
	
	// assign this page as a delegate
	locationManager.delegate = self;
	
	// ask LocationManager to give accurate location info as much as possible.
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
    
	// disable the 'Sleep mode'
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        //[locationManager requestAlwaysAuthorization];
    }
    
    // start tracking the path, call didUpdateToLocation callback
	[locationManager startUpdatingLocation];
    
    mapView.delegate = self;
    CLLocationCoordinate2D location;
    
    // set annotation.
    annotation = [[LocationAnnotation alloc]init];
    
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *item = [jsonArray objectAtIndex:i];
        
        location.latitude = [[item objectForKey:@"latitude"] doubleValue];
        location.longitude = [[item objectForKey:@"longitude"] doubleValue];
        
        annotation = [[LocationAnnotation alloc]initWithCoordinate:location];
        [annotation setCurrentTitle:[item objectForKey:@"mbrName"]];
        [annotation setCurrentID:[[item objectForKey:@"memberID"] intValue]];
        
        [mapView addAnnotation:annotation];
    }
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:FALSE];
    [mapView regionThatFits:region];
    mapView.showsUserLocation = YES;
    //    mapView.mapType = MKMapTypeStandard;
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
	
	MKUserLocation *userLocation = mapView.userLocation;
	CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
	[mapView setCenterCoordinate:coordinate animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currentLocation = (CLLocation *)[locations lastObject];
    NSLog(@"Location: %@", currentLocation);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	// do something below here, if we need user location data.
    NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)mapViewVar viewForAnnotation:(id <MKAnnotation>)annotationVar {
	
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotationVar reuseIdentifier:@"current"];
 
    if (annotationVar == [mapViewVar userLocation]) {
        return nil;
    }
	// if the pins are observation points
	else {
		
		annotationView.animatesDrop = YES;
		
		UIButton *btnDetailInfo = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		btnDetailInfo.frame = CGRectMake(0,0,23,23);
		btnDetailInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		btnDetailInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		
		annotationView.rightCalloutAccessoryView = btnDetailInfo;
		annotationView.canShowCallout = YES;
	}
    
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	LocationAnnotation *temp = view.annotation;
    
    NSLog(@"%@", temp);
    NSLog(@"%d", [temp getID]);
    
    // link to the view

    MTBRegisterationDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBRegisterationDetailViewController"];
	[viewController setMemID:[temp getID]];
//    [viewController setMemName:[jsonArray objectAtIndex:[temp.title]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) downloadContent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{};
    
    [manager POST:@"http://www.hourworld.org/db_mob/onLoad.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              jsonArray = [NSMutableArray arrayWithCapacity:0];
              [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
              
              [self setupMapView];
             
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    
    NSLog(@"movedUp: %hhd", movedUp);
    
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Pick an exchange [1/3]"];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillShow)
                                            name:UIKeyboardWillShowNotification
                                            object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillHide)
                                            name:UIKeyboardWillHideNotification
                                            object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                            name:UIKeyboardWillShowNotification
                                            object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                            name:UIKeyboardWillHideNotification
                                            object:nil];
    
    [super viewWillDisappear:animated];
}

@end

//
//  MTBAddMessageViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBAddMessageViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MTBAddMessageViewController ()

@end

@implementation MTBAddMessageViewController

@synthesize messageTxt, xDaysBtn, submitBtn, mapView, annotation, locationManager, actionSheet, pickerView, toolbar, message, datetime;

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    messageTxt.delegate = self;
    
    data = [[NSArray alloc]initWithObjects:@"14",@"13",@"12",@"11",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
    
    xDays = 0;
    
    // add borderline
    messageTxt.layer.borderColor = [[UIColor blackColor] CGColor];
    messageTxt.layer.borderWidth = 1.0f;
    
    // add a placeholder
    messageTxt.text = @"Add a thorough description";
    messageTxt.textColor = [UIColor lightGrayColor];
    
    // rounded corner
    xDaysBtn.layer.cornerRadius = 5;
    xDaysBtn.clipsToBounds = YES;

    [self setupMapView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddMessageViewController";
}

- (void)setupMapView {
    
    // set latitude, longitude.
    latitude = 0.0;
    longitude = 0.0;
    
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
    
    if(IS_OS_8_OR_LATER) {
        
        NSLog(@"this is iOS 8");
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
	
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
	
	// do something below here, if we need user location data.
    NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
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
    
    latitude = touchMapCoordinate.latitude;
    longitude = touchMapCoordinate.longitude;
    
    annotation = [[LocationAnnotation alloc]initWithCoordinate:touchMapCoordinate];
    [mapView addAnnotation:annotation];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    float prevPinchScale = 1.0;
    float thisScale = 1 + (pinch.scale-prevPinchScale);
    prevPinchScale = pinch.scale;
    self.view.transform = CGAffineTransformScale(self.view.transform, thisScale, thisScale);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [data count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [data objectAtIndex:row];
}

-(IBAction)pressxDaysBtn:(id)sender {
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 210)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.actionSheet addSubview:self.pickerView];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar setTintColor:[UIColor blackColor]];
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActionSheet)];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneActionSheet)];
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexSpaceItem, cancelBtnItem, doneBtnItem, nil]];
    [self.actionSheet addSubview:pickerToolbar];
    
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

-(void)cancelActionSheet {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)doneActionSheet {
    xDays = [[data objectAtIndex:[pickerView selectedRowInComponent:0]]intValue];
    
    if (xDays == 1) {
        [xDaysBtn setTitle:[NSString stringWithFormat:@"%d day", xDays] forState:UIControlStateNormal];
    }
    else {
        [xDaysBtn setTitle:[NSString stringWithFormat:@"%d days", xDays] forState:UIControlStateNormal];
    }
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)pressSubmitBtn:(id)sender {
    
    NSString *addedMessage = messageTxt.text;
    addedMessage = [addedMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"addedMessage: %@", addedMessage);
    
    if([addedMessage isEqual:@""]
       || [addedMessage isEqual:[NSNull null]]
       || [addedMessage rangeOfString:@"null"].location != NSNotFound
       || [addedMessage isEqualToString:@"Add a thorough description"]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please add a through description"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        if (xDays == 0) {
            xDays = 14;
        }
        
        NSDictionary *params = @{@"requestType"     :@"AddMsg,0",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"message"         :[NSString stringWithFormat:@"%@", addedMessage],
                                 @"lat"             :[NSString stringWithFormat:@"%f", latitude],
                                 @"lon"             :[NSString stringWithFormat:@"%f", longitude],
                                 @"oLat"            :[NSString stringWithFormat:@"%f", latitude],
                                 @"oLon"            :[NSString stringWithFormat:@"%f", longitude],
                                 @"dLat"            :[NSString stringWithFormat:@"%f", latitude],
                                 @"dLon"            :[NSString stringWithFormat:@"%f", longitude],
                                 @"xDays"           :[NSString stringWithFormat:@"%d", xDays]};
        
        NSLog(@"%f %f %f %f", latitude, longitude, latitude, longitude);
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                  if([responseObject objectForKey:@"success"]) {
                      NSLog(@"Complete uploading a message");

                      
                      NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                      [userDefault setInteger:1 forKey:@"reload"];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  else {
                      NSLog(@"Fail to upload a message");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:nil];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Failed to post your message. Please try again"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", operation);
              }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[self navigationItem] setTitle:@"Add Announcement"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Leave this page?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
        */
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [messageTxt endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add a thorough description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) { // when clicked "yes"
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end

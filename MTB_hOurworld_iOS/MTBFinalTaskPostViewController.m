//
//  MTBFinalTaskPostViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBFinalTaskPostViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "SecondViewController.h"
#import "MTBRequestViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MTBFinalTaskPostViewController ()

@end

@implementation MTBFinalTaskPostViewController

@synthesize taskDescription, submitBtn, mapBtn;
@synthesize serviceLabel;
@synthesize svcCatID, svcID, svcCat, service, isOffer, isRequest, item, isEdit;
@synthesize mapView, annotation, locationManager;

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
    
    if([isOffer isEqualToString:@"T"]) {
        NSString *serviceText = [NSString stringWithFormat:@"This offer will appear in \n'%@ > %@'", svcCat, service];
        [serviceLabel setText:serviceText];
    }
    else {
        NSString *serviceText = [NSString stringWithFormat:@"This request will appear in \n'%@ > %@'", svcCat, service];
        [serviceLabel setText:serviceText];
    }
    
    // initialize latitude, longitude.
    oLat = 0.0;
    oLon = 0.0;
    dLat = 0.0;
    dLon = 0.0;
    
    // rounded corner
    mapBtn.layer.cornerRadius = 5;
    mapBtn.clipsToBounds = YES;
    
    // add borderline textview
    taskDescription.layer.borderColor = [[UIColor blackColor] CGColor];
    taskDescription.layer.borderWidth = 1.0;
    
    // add a placeholder
    taskDescription.text = @"Add a thorough description";
    taskDescription.textColor = [UIColor lightGrayColor];
    
    // initialize locationManager
    locationManager = [[CLLocationManager alloc] init];
    
    // assign this page as a delegate
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"FinalTaskPostViewController";
}

- (void)addItemViewController:(MTBAddPushpinViewController *)controller oLatitude:(double)oLatitude oLongitude:(double)oLongitude dLatitude:(double)dLatitude dLongitude:(double)dLongitude {
 
    oLat = oLatitude;
    oLon = oLongitude;
    dLat = dLatitude;
    dLon = dLongitude;
    
    [mapView setHidden:NO];
    
    [self setupMapView];
}

- (void) setupMapView {

	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	CLLocationCoordinate2D location = CLLocationCoordinate2DMake(dLat, dLon);

    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 1;
	span.longitudeDelta = 1;
	
	region.span = span;
	region.center = location;
	
	[mapView setRegion:region animated:FALSE];
	[mapView regionThatFits:region];
    
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
    
    // set annotation.
    annotation = [[LocationAnnotation alloc]initWithCoordinate:location];
    [mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if([isOffer isEqualToString:@"T"]) {
        self.navigationItem.title = @"Add Offer";
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    else {
        self.navigationItem.title = @"Add Request";
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    [super viewWillAppear:animated];
}

- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [taskDescription endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add a thorough description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}
-(IBAction)pressMapBtn:(id)sender {
    MTBAddPushpinViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBAddPushpinViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)pressSubmitBtn:(id)sender {
    NSString *addedDescription = taskDescription.text;
    addedDescription = [addedDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([addedDescription isEqual:@""]
       || [addedDescription isEqual:[NSNull null]]
       || [addedDescription rangeOfString:@"null"].location != NSNotFound
       || [addedDescription isEqualToString:@"Add a thorough description"]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please check a description"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
    else {
        // start downloading
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"AddTask,SAVE",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"SvcCatID"        :[NSString stringWithFormat:@"%ld", (long)svcCatID],
                                 @"SvcID"           :[NSString stringWithFormat:@"%ld", (long)svcID],
                                 @"Offer"           :[NSString stringWithFormat:@"%@", isOffer],
                                 @"Request"         :[NSString stringWithFormat:@"%@", isRequest],
                                 @"Expire"          :@"365",
                                 @"Descr"           :[NSString stringWithFormat:@"%@", addedDescription],
                                 @"oLat"            :[NSString stringWithFormat:@"%f", oLat],
                                 @"oLon"            :[NSString stringWithFormat:@"%f", oLon],
                                 @"dLat"            :[NSString stringWithFormat:@"%f", dLat],
                                 @"dLon"            :[NSString stringWithFormat:@"%f", dLon]};
        
        
        
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                  if([responseObject objectForKey:@"success"]) {
                      NSLog(@"Complete uploading a task");
                      
                      NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                      [userDefault setInteger:1 forKey:@"reload"];
                      [self.navigationController popViewControllerAnimated:YES];
                      
                      /*
                      if([isOffer isEqualToString:@"T"]) {
                          NSArray *viewControllers = [[self navigationController] viewControllers];
                          for(int i=0 ; i<[viewControllers count] ; i++){
                              id obj=[viewControllers objectAtIndex:i];
                              if([obj isKindOfClass:[SecondViewController class]]){
                                  [[self navigationController] popToViewController:obj animated:YES];
                                  return;
                              }
                          }
                      }
                      else {
                          NSArray *viewControllers = [[self navigationController] viewControllers];
                          for(int i=0 ; i<[viewControllers count] ; i++){
                              id obj=[viewControllers objectAtIndex:i];
                              if([obj isKindOfClass:[MTBRequestViewController class]]){
                                  [[self navigationController] popToViewController:obj animated:YES];
                                  return;
                              }
                          }
                      }
                       */
         
                  }
                  else {
                      NSLog(@"Fail to upload a task");
                      
                      UIAlertView *dialog = [[UIAlertView alloc]init];
                      [dialog setDelegate:self];
                      [dialog setTitle:@"Message"];
                      [dialog setMessage:@"Failed to post your task. Please try again"];
                      [dialog addButtonWithTitle:@"Close"];
                      [dialog show];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", operation);
              }];
    }
}

@end

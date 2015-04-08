//
//  MTBTaskEditViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Kyungsik Han on 9/16/14.
//  Copyright (c) 2014 HCI PSU. All rights reserved.
//

#import "MTBTaskEditViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"
#import "SecondViewController.h"
#import "MTBTaskDetailViewController.h"
#import "MTBTaskCategoryServiceTaskViewController.h"

@interface MTBTaskEditViewController ()

@end

@implementation MTBTaskEditViewController

@synthesize taskDescription, submitBtn, mapBtn;
@synthesize serviceLabel;
@synthesize svcCatID, svcID, svcCat, service, isOffer, isRequest, item;
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
        NSString *serviceText = [NSString stringWithFormat:@"This offer will appear in \n'%@ > %@'", item.mSvcCat, item.mService];
        [serviceLabel setText:serviceText];
        isRequest = @"F";
    }
    else {
        NSString *serviceText = [NSString stringWithFormat:@"This request will appear in \n'%@ > %@'", item.mSvcCat, item.mService];
        [serviceLabel setText:serviceText];
        isRequest = @"T";
    }
    
    // update oLat, oLon, dLat, dLon
    oLat = item.mOLat;
    oLon = item.mOLon;
    dLat = item.mDLat;
    dLon = item.mDLon;
    
    NSLog(@"%f %f", dLat, dLon);
    
    if (dLat != 0.0 && dLon != 0.0) {
        [mapView setHidden:NO];
        [self setupMapView];
    }
    
    // rounded corner
    mapBtn.layer.cornerRadius = 5;
    mapBtn.clipsToBounds = YES;
    
    // add borderline textview
    taskDescription.layer.borderColor = [[UIColor blackColor] CGColor];
    taskDescription.layer.borderWidth = 1.0;
    
    // add a placeholder
    taskDescription.text = item.mDescription;
    //taskDescription.textColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"EditTaskViewController";
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
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
	
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
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Edit_task", nil)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc]
                                      initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Back", nil)]
                                      style: UIBarButtonItemStyleBordered target:nil action:nil];
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
    if ([textView.text isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"Add_thorough_description", nil)]]) {
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
       || [addedDescription isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"Add_thorough_description", nil)]]) {
        
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:self];
        [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
        [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Please_check_description", nil)]];
        [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
        [dialog show];
    }
    else {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *params = @{@"requestType"     :@"EditTask,SAVE",
                                 @"accessToken"     :[userDefault objectForKey:@"access_token"],
                                 @"EID"             :[userDefault objectForKey:@"EID"],
                                 @"memID"           :[userDefault objectForKey:@"memID"],
                                 @"SvcCatID"        :[NSString stringWithFormat:@"%ld", (long)item.mSvcCatID],
                                 @"SvcID"           :[NSString stringWithFormat:@"%ld", (long)item.mSvcID],
                                 @"Offer"           :isOffer,
                                 @"Request"         :isRequest,
                                 @"Expire"          :@"365",
                                 @"Descr"           :[NSString stringWithFormat:@"%@", addedDescription],
                                 @"oLat"            :[NSString stringWithFormat:@"%f", oLat],
                                 @"oLon"            :[NSString stringWithFormat:@"%f", oLon],
                                 @"dLat"            :[NSString stringWithFormat:@"%f", dLat],
                                 @"dLon"            :[NSString stringWithFormat:@"%f", dLon]
                                 };
        
        [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
               if([responseObject objectForKey:@"success"]) {
                   NSLog(@"Complete editing a task");
                   
                   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                   [userDefault setInteger:1 forKey:@"reload"];
                   
                   if([isOffer isEqualToString:@"T"]) {
                       NSArray *viewControllers = [[self navigationController] viewControllers];
                       for(int i=0 ; i<[viewControllers count] ; i++){
                           id obj=[viewControllers objectAtIndex:i];
                           if([obj isKindOfClass:[MTBTaskCategoryServiceTaskViewController class]]){
                               [[self navigationController] popToViewController:obj animated:YES];
                               return;
                           }
                       }
                   }
                   else {
                       NSArray *viewControllers = [[self navigationController] viewControllers];
                       for(int i=0 ; i<[viewControllers count] ; i++){
                           id obj=[viewControllers objectAtIndex:i];
                           if([obj isKindOfClass:[MTBTaskCategoryServiceTaskViewController class]]){
                               [[self navigationController] popToViewController:obj animated:YES];
                               return;
                           }
                       }
                   }
               }
               else {
                   NSLog(@"Fail to upload a task");
                   
                   UIAlertView *dialog = [[UIAlertView alloc]init];
                   [dialog setDelegate:self];
                   [dialog setTitle:[NSString stringWithFormat:NSLocalizedString(@"Message", nil)]];
                   [dialog setMessage:[NSString stringWithFormat:NSLocalizedString(@"Fail_to_edit", nil)]];
                   [dialog addButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Close", nil)]];
                   [dialog show];
               }
               
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"Error: %@", operation);
           }];
    }
}

@end

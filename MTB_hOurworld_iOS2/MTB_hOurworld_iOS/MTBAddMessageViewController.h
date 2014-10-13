//
//  MTBAddMessageViewController.h
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/15/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"
#import "GAITrackedViewController.h"

@interface MTBAddMessageViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate> {
    IBOutlet UITextView *messageTxt;
    IBOutlet UIBarButtonItem *submitBtn;
    IBOutlet UIButton *xDaysBtn;
    IBOutlet MKMapView *mapView;
    
    LocationAnnotation *annotation;
    CLLocationManager *locationManager;
    
    double latitude;
    double longitude;
    
    UIActionSheet *actionSheet;
    UIPickerView *pickerView;
    UIToolbar *toolbar;
    
    NSArray *data;
    
    int xDays;
    
    NSString *message;
    NSString *datetime;

}

@property (nonatomic, retain) IBOutlet UITextView *messageTxt;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitBtn;
@property (nonatomic ,retain) IBOutlet UIButton *xDaysBtn;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) LocationAnnotation *annotation;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIToolbar *toolbar;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *datetime;

-(IBAction)pressSubmitBtn:(id)sender;
-(IBAction)pressxDaysBtn:(id)sender;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

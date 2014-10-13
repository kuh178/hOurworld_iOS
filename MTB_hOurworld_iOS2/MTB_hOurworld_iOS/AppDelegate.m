//
//  AppDelegate.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/5/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "AppDelegate.h"
//#import <LookBack/LookBack.h>
#import "MTBLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GAI.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface AppDelegate ()
//@property (nonatomic) LookBack *lookback;
@end

#define IS_4_INCH_DEVICE CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(568, 320))

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //LookBack is only compatible with iOS 6 and above
    //[LookBack setupWithAppToken:@"c2YMQ3RSctSyHZ9ry"];
    
    //UIButton *lookbackSettingButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //lookbackSettingButton.frame = CGRectMake(250, 30, 25, 25);
    //[lookbackSettingButton addTarget:self action:@selector(showLookbackSettings:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationController *navigationController = [[UINavigationController alloc]init];
    //self.window.rootViewController = navigationController;
    
    //[self.window addSubview:lookbackSettingButton];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.

    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-45467711-1"];
    
    // Enable IDFA collection.
//    [tracker setAllowIDFACollection:@YES];
//    [tracker set:allowIDFACollection value:@YES];
    
    UIStoryboard *storyBoard = nil;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    // choosing the right storyboard
    if (iOSDeviceScreenSize.height == 480 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
            storyBoard = [UIStoryboard storyboardWithName:@"StoryBoard_3.5inch_iOS56" bundle:nil];
        }
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            storyBoard = [UIStoryboard storyboardWithName:@"StoryBoard_3.5inch_iOS7" bundle:nil];
        }
    }
    if (iOSDeviceScreenSize.height == 568) {

        storyBoard = [UIStoryboard storyboardWithName:@"StoryBoard_4inch" bundle:nil];
    }
    
    UIViewController *initialViewController = [storyBoard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = initialViewController;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(18/255.0) green:(165/255.0) blue:(244/255.0) alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"ArialMT" size:18.0],
                                                          NSFontAttributeName,
                                                          [UIColor whiteColor],
                                                          NSForegroundColorAttributeName, nil]];
    return YES;
}

/*
- (IBAction)showLookbackSettings:(id)sender {
    UIViewController *vc = [GFSettingsViewController settingsViewControllerForInstance:[LookBack lookback]];
    [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
    
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Update"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/app/hourworld"]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // get the current version of the app
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSLog(@"current version of the app: %@", version);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://community.ist.psu.edu/version/get_hourworld_ios_version.php?version=%@", version] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString *responseString = [responseObject responseString];
        
        if([responseString isEqual:@"UPDATE"]) {
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"update"];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"hOurworld has a newer version. Do you want to update the app?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Update"
                                                    otherButtonTitles:@"Cancel", nil];
            [message show];   
        }
        else {
            NSLog(@"no update needed");
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"update"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

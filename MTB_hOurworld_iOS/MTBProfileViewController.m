//
//  MTBProfileViewController.m
//  MTB_hOurworld_iOS
//
//  Created by Keith Kyungsik Han on 6/14/13.
//  Copyright (c) 2013 HCI PSU. All rights reserved.
//

#import "MTBProfileViewController.h"

#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

#import "MTBReportHoursViewController.h"
#import "MTBLoginViewController.h"

#import "MTBOffersRequestsViewController.h"
#import "MTBProfileEditBioViewController.h"
#import "MTBProfileEditContactViewController.h"

#import "CustomIOS7AlertView.h"

@interface MTBProfileViewController ()

@end

@implementation MTBProfileViewController

@synthesize memID, profileImageView, usernameLabel, summaryLabel, bioLabel, contactInfo, scrollView, offersLabel, offersTitleLabel, offersLine, requestsLabel, requestsTitleLabel, requestsLine, reportHourBtn, creditHistoryBtn, shareMyLocLabel, shareMyLocSwitch;
@synthesize logoutBtn;
@synthesize editBio, editContact;
@synthesize badgeImageView1, badgeImageView2, badgeImageView3, badgeImageView4, badgeImageView5,badgeImageView6;
@synthesize activityIndicator;

@synthesize contactHomeBtn;
@synthesize contactMobileBtn;
@synthesize contactEmailBtn;
@synthesize contactWebBtn;

NSMutableArray *offerAry, *requestAry, *badgeArray;
NSString *creditProvided, *creditReceived;
NSUserDefaults *userDefault;

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
    
    activityIndicator.startAnimating;
    
    height = 0;
    
    contactHomeBtn.layer.cornerRadius = 5;
    contactHomeBtn.clipsToBounds = YES;
    contactHomeBtn.alpha = 0.2;
    
    contactMobileBtn.layer.cornerRadius = 5;
    contactMobileBtn.clipsToBounds = YES;
    contactMobileBtn.alpha = 0.2;
    
    contactEmailBtn.layer.cornerRadius = 5;
    contactEmailBtn.clipsToBounds = YES;
    contactEmailBtn.alpha = 0.2;
    
    contactWebBtn.layer.cornerRadius = 5;
    contactWebBtn.clipsToBounds = YES;
    contactWebBtn.alpha = 0.2;
    
    userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"memID"] == memID) {
        [reportHourBtn setHidden:YES];
        [logoutBtn setEnabled:YES];
        [shareMyLocLabel setHidden:NO];
        [shareMyLocSwitch setHidden:NO];
        [editContact setHidden:NO];
        [editBio setHidden:NO];
    }
    else {
        [reportHourBtn setHidden:YES];
        [logoutBtn setEnabled:NO];
        [shareMyLocLabel setHidden:YES];
        [shareMyLocSwitch setHidden:YES];
        [editContact setHidden:YES];
        [editBio setHidden:YES];
    }
    
    if ([userDefault boolForKey:@"location"] == TRUE) {
        [shareMyLocSwitch setOn:YES];
    }
    else {
        [shareMyLocSwitch setOn:NO];
    }
    
    [creditHistoryBtn setEnabled:NO];
    
    [self loadProfileInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ProfileViewController";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadProfileInfo {
    // start downloading
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *params = @{@"requestType"     :[NSString stringWithFormat:@"ProfileB,%@:%d", [userDefault objectForKey:@"EID"], memID],
                             @"accessToken"     :[userDefault objectForKey:@"access_token"],
                             @"EID"             :[userDefault objectForKey:@"EID"],
                             @"memID"           :[userDefault objectForKey:@"memID"]};
    
    [manager POST:@"http://www.hourworld.org/db_mob/auth.php" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [activityIndicator stopAnimating];
                activityIndicator.hidden = YES;
                
              [self showProfile:responseObject];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", operation);
          }];
}

- (void)showProfile:(id) request {

    if ([[request objectForKey:@"success"]boolValue] == TRUE) {
        NSMutableArray *jAry = [NSMutableArray arrayWithCapacity:0];
        [jAry addObjectsFromArray:[request objectForKey:@"results"]];
        
        NSDictionary *item = [jAry objectAtIndex:0];
        
        NSLog(@"%@", item);
        
        username = [item objectForKey:@"listMbrName"];
        profileImage = [item objectForKey:@"Profile"];
        profileImage = [profileImage stringByReplacingOccurrencesOfString:@".." withString:@""];
        
        city = [item objectForKey:@"City"];
        bio = [item objectForKey:@"Bio"];
        
        // clean a bio string
        if(bio != (id)[NSNull null] && [bio length] > 0) {
            bio = [bio stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            bio = [bio stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            bio = [bio stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
            bio = [bio stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
        }
        else {
            bio = @"No bio information";
        }
        
        totalTrans = [[item objectForKey:@"totalTrans"] intValue];
        totalMbrs = [[item objectForKey:@"totalMbrs"] intValue];
        revCount = [[item objectForKey:@"RcvCount"] intValue];
        satPct = [[item objectForKey:@"SatPct"] intValue];
        
        if (![[item objectForKey:@"ContactArray"] isEqual:[NSNull null]]) {
            NSMutableArray *contactAry = [NSMutableArray arrayWithCapacity:0];
            [contactAry addObjectsFromArray:[item objectForKey:@"ContactArray"]];
            
            contact = @"";
            
            email1 = home1 = mobile = website = @"";
            
            bool emailExist = false;
            bool homeExist = false;
            bool mobileExist = false;
            bool webExist = false;
            
            for (int i = 0 ; i < [contactAry count] ; i++) {
                NSDictionary *contactItem = [contactAry objectAtIndex:i];
                
                if([[contactItem objectForKey:@"contactType"] isEqualToString:@"Email1"]) {
                    email1 = [contactItem objectForKey:@"contactInfo"];
                    emailExist = true;
                }
                if([[contactItem objectForKey:@"contactType"] isEqualToString:@"Home1"]) {
                    home1 = [contactItem objectForKey:@"contactInfo"];
                    homeExist = true;
                }
                if([[contactItem objectForKey:@"contactType"] isEqualToString:@"Mobile"]) {
                    mobile = [contactItem objectForKey:@"contactInfo"];
                    mobileExist = true;
                }
                if([[contactItem objectForKey:@"contactType"] isEqualToString:@"Website"]) {
                    website = [contactItem objectForKey:@"contactInfo"];
                    webExist = true;
                }
                
                contact = [contact stringByAppendingString:[NSString stringWithFormat:@"%@\n", [contactItem objectForKey:@"contactInfo"]]];
            }
            
            [contactEmailBtn setHidden:NO];
            [contactHomeBtn setHidden:NO];
            [contactMobileBtn setHidden:NO];
            [contactWebBtn setHidden:NO];
            
            if (emailExist) {
                [contactEmailBtn setEnabled:YES];
                [contactEmailBtn setAlpha:1.0];
            }
            else {
                [contactEmailBtn setEnabled:NO];
                [contactEmailBtn setAlpha:0.2];
            }
            
            if (homeExist) {
                [contactHomeBtn setEnabled:YES];
                [contactHomeBtn setAlpha:1.0];
            }
            else {
                [contactHomeBtn setEnabled:NO];
                [contactHomeBtn setAlpha:0.2];
            }
            
            if (mobileExist) {
                [contactMobileBtn setEnabled:YES];
                [contactMobileBtn setAlpha:1.0];
            }
            else {
                [contactMobileBtn setEnabled:NO];
                [contactMobileBtn setAlpha:0.2];
            }
            
            if (webExist) {
                [contactWebBtn setEnabled:YES];
                [contactWebBtn setAlpha:1.0];
            }
            else {
                [contactWebBtn setEnabled:NO];
                [contactWebBtn setAlpha:0.2];
            }
        }
       
        
        offerAry = [NSMutableArray arrayWithCapacity:0];
        requestAry = [NSMutableArray arrayWithCapacity:0];
        
        NSString *offerList = @"";
        NSString *requestList = @"";
        
        NSMutableArray *specializedArray = [NSMutableArray arrayWithCapacity:0];
        
        if (![[item objectForKey:@"OffersArray"] isEqual:[NSNull null]]) {
            [offerAry addObjectsFromArray:[item objectForKey:@"OffersArray"]];
            
            for (int i = 0 ; i < [offerAry count]; i++) {
                NSDictionary *offerItem = [offerAry objectAtIndex:i];
                
                NSString *desc = [offerItem objectForKey:@"SvcDescr"];
                
                if (![desc isEqual:[NSNull null]] && [desc length] > 5 && ![desc isEqualToString:@"Please add a description!"]) {
                    desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    desc = [desc stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                    desc = [desc stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
                    desc = [desc stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
                    
                    if (i == [offerAry count] - 1) {
                        offerList = [offerList stringByAppendingString:[NSString stringWithFormat:@"%@", desc]];
                    }
                    else {
                        offerList = [offerList stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", desc]];
                    }
                    
                    if ([specializedArray count] == 0) {
                        NSMutableDictionary *newObj = [[NSMutableDictionary alloc] init];
                        [newObj setObject:[NSString stringWithFormat:@"%@", [offerItem objectForKey:@"SvcCat"]] forKey:@"SvcCat"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", [[offerItem objectForKey:@"SvcCatID"] intValue]] forKey:@"SvcCatID"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"SvcCatCnt"];
                        
                        [specializedArray addObject:newObj];
                    }
                    
                    int count = 0;
                    
                    for (int j = 0 ; j < [specializedArray count] ; j++) {
                        
                        if ([[[specializedArray objectAtIndex:j] objectForKey:@"SvcCatID"] isEqualToString:[offerItem objectForKey:@"SvcCatID"]]) {
                            int keyCount = [[[specializedArray objectAtIndex:j] objectForKey:@"SvcCatCnt"] intValue];
                            [[specializedArray objectAtIndex:j] setObject:[NSString stringWithFormat:@"%d", keyCount+1] forKey:@"SvcCatCnt"];
                        }
                        else {
                            count++;
                        }
                    }
                    
                    if (count == [specializedArray count]) {
                        NSMutableDictionary *newObj = [[NSMutableDictionary alloc] init];
                        [newObj setObject:[NSString stringWithFormat:@"%@", [offerItem objectForKey:@"SvcCat"]] forKey:@"SvcCat"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", [[offerItem objectForKey:@"SvcCatID"] intValue]] forKey:@"SvcCatID"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"SvcCatCnt"];
                        
                        [specializedArray addObject:newObj];
                    }
                }
                else {
                    // continue
                }
            }
        
            [self stringHTMLHandler:offerList];
        }
        else {
            offerList = @"No offer";
        }
        
        if (![[item objectForKey:@"RequestsArray"] isEqual:[NSNull null]]) {
            [requestAry addObjectsFromArray:[item objectForKey:@"RequestsArray"]];
            
            for (int i = 0 ; i < [requestAry count]; i++) {
                NSDictionary *requestItem = [requestAry objectAtIndex:i];
                
                NSString *desc = [requestItem objectForKey:@"SvcDescr"];
                
                if (![desc isEqual:[NSNull null]] && [desc length] > 5 && ![desc isEqualToString:@"Please add a description!"]) {
                    desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    desc = [desc stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                    desc = [desc stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
                    desc = [desc stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
                    
                    if (i == [requestAry count] - 1) {
                        requestList = [requestList stringByAppendingString:[NSString stringWithFormat:@"%@", desc]];
                    }
                    else {
                        requestList = [requestList stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", desc]];
                    }
                    
                    if ([specializedArray count] == 0) {
                        NSMutableDictionary *newObj = [[NSMutableDictionary alloc] init];
                        [newObj setObject:[NSString stringWithFormat:@"%@", [requestItem objectForKey:@"SvcCatID"]] forKey:@"SvcCatID"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", [[requestItem objectForKey:@"SvcID"] intValue]] forKey:@"SvcID"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"SvcCatCnt"];
                        
                        [specializedArray addObject:newObj];
                    }
                    
                    int count = 0;
                    
                    for (int j = 0 ; j < [specializedArray count] ; j++) {
                        
                        if ([[[specializedArray objectAtIndex:j] objectForKey:@"SvcCatID"] isEqualToString:[requestItem objectForKey:@"SvcCatID"]]) {
                            int keyCount = [[[specializedArray objectAtIndex:j] objectForKey:@"SvcCatCnt"] intValue];
                            [[specializedArray objectAtIndex:j] setObject:[NSString stringWithFormat:@"%d", keyCount+1] forKey:@"SvcCatCnt"];
                        }
                        else {
                            count++;
                        }
                    }
                    
                    if (count == [specializedArray count]) {
                        NSMutableDictionary *newObj = [[NSMutableDictionary alloc] init];
                        [newObj setObject:[NSString stringWithFormat:@"%@", [requestItem objectForKey:@"SvcCat"]] forKey:@"SvcCat"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", [[requestItem objectForKey:@"SvcID"] intValue]] forKey:@"SvcID"];
                        [newObj setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"SvcCatCnt"];
                        
                        [specializedArray addObject:newObj];
                    }
                }
                else {
                    //continue
                }
            }
            [self stringHTMLHandler:requestList];
        }
        else {
            requestList = @"No request";
        }
        
        NSString *specials;
        // have array sorted
        if ([specializedArray count] == 0) {
            specials = @"No information";
        }
        else {
            NSArray *sortedspecializedArray;
            sortedspecializedArray = [specializedArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [a objectForKey:@"SvcCatCnt"];
                NSString *second = [b objectForKey:@"SvcCatCnt"];
                return [first compare:second];
            }];
            
            NSLog(@"%@", sortedspecializedArray);
            unsigned long sortedspecializedArrayLength = [sortedspecializedArray count];
            
            if (sortedspecializedArrayLength >= 3) {
                specials = [NSString stringWithFormat:@"\u2022 %@\n\u2022 %@\n\u2022 %@",
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-1)] objectForKey:@"SvcCat"],
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-2)] objectForKey:@"SvcCat"],
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-3)] objectForKey:@"SvcCat"]];
            }
            else if (sortedspecializedArrayLength == 2) {
                specials = [NSString stringWithFormat:@"\u2022 %@\n\u2022 %@\n",
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-1)] objectForKey:@"SvcCat"],
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-2)] objectForKey:@"SvcCat"]];
            }
            else {
                specials = [NSString stringWithFormat:@"\u2022 %@\n",
                            [[sortedspecializedArray objectAtIndex:(sortedspecializedArrayLength-1)] objectForKey:@"SvcCat"]];
            }
        }
        
        // username
        usernameLabel.text = username;

        // profile image
        [profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hourworld.org/%@", profileImage]] placeholderImage:[UIImage imageNamed:@"who_checkin_default.png"]];
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = YES;
        self.profileImageView.layer.borderWidth = 1.0f;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        NSString *balanceStr = @"";
        NSString *requestStr = @"";
        NSString *offerStr = @"";
        NSString *exchangeStr = @"";
        NSString *completedMemberStr = @"";
        
        if ([creditProvided floatValue]-[creditReceived floatValue] > 1.0
            || [creditProvided floatValue]-[creditReceived floatValue] < -1.0) {
            balanceStr = [NSString stringWithFormat:@"%.1f hours",[creditProvided floatValue]-[creditReceived floatValue]];
        }
        else {
            balanceStr = [NSString stringWithFormat:@"%.1f hour",[creditProvided floatValue]-[creditReceived floatValue]];
        }
        
        if ([requestAry count] > 1) {
            requestStr = [NSString stringWithFormat:@"%lu requests",(unsigned long)[requestAry count]];
        }
        else {
            requestStr = [NSString stringWithFormat:@"%lu request",(unsigned long)[requestAry count]];
        }
        
        if ([offerAry count] > 1) {
            offerStr = [NSString stringWithFormat:@"%lu offers",(unsigned long)[offerAry count]];
        }
        else {
            offerStr = [NSString stringWithFormat:@"%lu offer",(unsigned long)[offerAry count]];
        }
        
        if (totalTrans > 1) {
            exchangeStr = [NSString stringWithFormat:@"%d exchanges",totalTrans];
        }
        else {
            exchangeStr = [NSString stringWithFormat:@"%d exchange",totalTrans];
        }
        
        if (totalMbrs > 1) {
            completedMemberStr = [NSString stringWithFormat:@"%d members",totalMbrs];
        }
        else {
            completedMemberStr = [NSString stringWithFormat:@"%d member",totalMbrs];
        }
        
        // activity
        NSString *activity = [NSString stringWithFormat:
                              @"\u2022 Balance: %@\n\u2022 Posted %@ and %@\n\u2022 Completed %@ with %@\n\u2022 %d%% user satisfaction\n\nSpecialized in\n%@",
                              balanceStr,
                              requestStr,
                              offerStr,
                              exchangeStr,
                              completedMemberStr,
                              satPct,
                              specials];
        
        // badges (we only use 6 types in the app)
        if (![[item objectForKey:@"BadgeArray"] isEqual:[NSNull null]]) {
            
            badgeArray = [item objectForKey:@"BadgeArray"];
            
            NSLog(@"%@", badgeArray);
            
            if (![[badgeArray[0] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                totalServices = [badgeArray[0] componentsSeparatedByString:@","][0];
                totalServicesTitle = [badgeArray[0] componentsSeparatedByString:@","][1];
            }
            else {
                totalServices = @"";
                totalServicesTitle = @"";
            }
            
            
            if (![[badgeArray[1] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                totalReceives = [badgeArray[1] componentsSeparatedByString:@","][0];
                totalReceivesTitle = [badgeArray[1] componentsSeparatedByString:@","][1];
            }
            else {
                totalReceives = @"";
                totalReceivesTitle = @"";
            }
            
            if (![[badgeArray[2] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                totalExcHours = [badgeArray[2] componentsSeparatedByString:@","][0];
                totalExcHoursTitle = [badgeArray[2] componentsSeparatedByString:@","][1];
            }
            else {
                totalExcHours = @"";
                totalExcHoursTitle = @"";
            }
            
            if (![[badgeArray[3] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                totalRefs = [badgeArray[3] componentsSeparatedByString:@","][0];
                totalRefsTitle = [badgeArray[3] componentsSeparatedByString:@","][1];
                
                NSLog(@"totalRefsTitle: %@", totalRefsTitle);
            }
            else {
                totalRefs = @"";
                totalRefsTitle = @"";
            }
            /*
            if (![[badgeArray[4] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                totalGroups = [badgeArray[4] componentsSeparatedByString:@","][0];
                totalGroupsTitle = [badgeArray[4] componentsSeparatedByString:@","][1];
            }
            else {
                totalGroups = @"";
                totalGroupsTitle = @"";
            }
            */
            
            if (![badgeArray[5] isEqual:[NSNull null]]) {
                if (![[badgeArray[5] componentsSeparatedByString:@","] isEqual:[NSNull null]]) {
                    diversity = [badgeArray[5] componentsSeparatedByString:@","][0];
                    diversityTitle = [badgeArray[5] componentsSeparatedByString:@","][1];
                }
            }
            else {
                diversity = @"https://hourworld.org/db_icons/Div/00.png";
                diversityTitle = @"No exchanges with different members yet.";
            }
            
            /*
            if (![[badgeArray[6] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                pageVisits = [badgeArray[6] componentsSeparatedByString:@","][0];
                pageVisitsTitle = [badgeArray[6] componentsSeparatedByString:@","][1];
            }
            else {
                pageVisits = @"";
                pageVisitsTitle = @"";
            }
            */
            if (![[badgeArray[7] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                consecMo = [badgeArray[7] componentsSeparatedByString:@","][0];
                consecMoTitle = [badgeArray[7] componentsSeparatedByString:@","][1];
            }
            else {
                consecMo = @"";
                consecMoTitle = @"";
            }
            /*
            if (![[badgeArray[8] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                orientation = [badgeArray[8] componentsSeparatedByString:@","][0];
                orientationTitle = [badgeArray[8] componentsSeparatedByString:@","][1];
            }
            else {
                orientation = @"";
                orientationTitle = @"";
            }
            */
            /*
            if (![[badgeArray[9] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                profileImageDone = [badgeArray[9] componentsSeparatedByString:@","][0];
                profileImageDoneTitle = [badgeArray[9] componentsSeparatedByString:@","][1];
            }
            else {
                profileImageDone = @"";
                profileImageDoneTitle = @"";
            }
            */
            /*
            if (![[badgeArray[10] componentsSeparatedByString:@","][0] isEqual:[NSNull null]]) {
                advTraining = [badgeArray[10] componentsSeparatedByString:@","][0];
                advTrainingTitle = [badgeArray[10] componentsSeparatedByString:@","][1];
            }
            else {
                advTraining = @"";
                advTrainingTitle = @"";
            }
            */
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped1:)];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped2:)];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped3:)];
            UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped4:)];
            UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped5:)];
            UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped6:)];
            
            // total service
            [badgeImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", totalServices]]];
            // totalReceives
            [badgeImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", totalReceives]]];
            // diversity
            [badgeImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", diversity]]];
            // totalExcHours
            [badgeImageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", totalExcHours]]];
            // totalRefs
            [badgeImageView5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", totalRefs]]];
            // consecMo
            [badgeImageView6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", consecMo]]];
            
            badgeImageView1.userInteractionEnabled = YES;
            badgeImageView2.userInteractionEnabled = YES;
            badgeImageView3.userInteractionEnabled = YES;
            badgeImageView4.userInteractionEnabled = YES;
            badgeImageView5.userInteractionEnabled = YES;
            badgeImageView6.userInteractionEnabled = YES;
            
            [badgeImageView1 addGestureRecognizer:tap1];
            [badgeImageView2 addGestureRecognizer:tap2];
            [badgeImageView3 addGestureRecognizer:tap3];
            [badgeImageView4 addGestureRecognizer:tap4];
            [badgeImageView5 addGestureRecognizer:tap5];
            [badgeImageView6 addGestureRecognizer:tap6];
            
            NSLog(@"%@", totalServices);
            NSLog(@"%@", totalReceives);
            NSLog(@"%@", totalExcHours);
            NSLog(@"%@", totalRefs);
            //NSLog(@"%@", totalGroups);
            NSLog(@"%@", diversity);
            //NSLog(@"%@", pageVisits);
            NSLog(@"%@", consecMo);
            //NSLog(@"%@", orientation);
            //NSLog(@"%@", profileImageDone);
            //NSLog(@"%@", advTraining);
        }
        
        //Calculate the expected size based on the font and linebreak mode of your label
        bioLabel.frame = [self calculateSize:bio Label:bioLabel];
        addressLabel.frame = [self calculateSize:city Label:addressLabel];
        summaryLabel.frame = [self calculateSize:activity Label:summaryLabel];
        offersLabel.frame = [self calculateSize:offerList Label:offersLabel];
        requestsLabel.frame = [self calculateSize:requestList Label:requestsLabel];
        
        bio = [self stringHTMLHandler:bio];
        
        bioLabel.text = bio;
        addressLabel.text = [NSString stringWithFormat:@"Lives in %@", city];
        summaryLabel.text = activity;
        contactInfo.text = contact;
        offersLabel.text = offerList;
        requestsLabel.text = requestList;
        
        NSLog(@"contact : %@", contact);
        
        height += bioLabel.frame.size.height;
        height += addressLabel.frame.size.height;
        height += summaryLabel.frame.size.height;
        height += contactInfo.frame.size.height;
        height += offersLabel.frame.size.height;
        height += requestsLabel.frame.size.height;
        height += 200;
        
        offersLabel.frame = CGRectMake(offersLabel.frame.origin.x,
                                       offersLabel.frame.origin.y + bioLabel.frame.size.height,
                                       offersLabel.frame.size.width,
                                       offersLabel.frame.size.height);
        offersTitleLabel.frame = CGRectMake(offersTitleLabel.frame.origin.x,
                                            offersTitleLabel.frame.origin.y + bioLabel.frame.size.height,
                                            offersTitleLabel.frame.size.width,
                                            offersTitleLabel.frame.size.height);
        offersLine.frame = CGRectMake(offersLine.frame.origin.x,
                                      offersLine.frame.origin.y + bioLabel.frame.size.height,
                                      offersLine.frame.size.width,
                                      offersLine.frame.size.height);
        
        requestsLabel.frame = CGRectMake(requestsLabel.frame.origin.x,
                                         requestsLabel.frame.origin.y + bioLabel.frame.size.height + offersLabel.frame.size.height,
                                         requestsLabel.frame.size.width,
                                         requestsLabel.frame.size.height);
        requestsTitleLabel.frame = CGRectMake(requestsTitleLabel.frame.origin.x,
                                              requestsTitleLabel.frame.origin.y + bioLabel.frame.size.height + offersLabel.frame.size.height,
                                              requestsTitleLabel.frame.size.width,
                                              requestsTitleLabel.frame.size.height);
        requestsLine.frame = CGRectMake(requestsLine.frame.origin.x,
                                        requestsLine.frame.origin.y + bioLabel.frame.size.height + offersLabel.frame.size.height,
                                        requestsLine.frame.size.width,
                                        requestsLine.frame.size.height);
        
        scrollView.contentSize = CGSizeMake(320, height);
        
        if (![[item objectForKey:@"Balances"] isEqual:[NSNull null]]) {
            NSMutableArray *balanceArray = [item objectForKey:@"Balances"];
            
            creditProvided = [[balanceArray objectAtIndex:0] objectForKey:@"provided"];
            creditReceived = [[balanceArray objectAtIndex:0] objectForKey:@"received"];
        }
        
        [creditHistoryBtn setEnabled:YES];
    }
}

- (void)tapped1:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:totalServicesTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}

- (void)tapped2:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:totalReceivesTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}

- (void)tapped3:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:diversityTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}

- (void)tapped4:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:totalExcHoursTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}


- (void)tapped5:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:totalRefsTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}

- (void)tapped6:(UITapGestureRecognizer*)tap{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:consecMoTitle
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Close", nil];
    [message show];
}

- (NSString *) stringHTMLHandler:(NSString *) string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
    
    return string;
}

- (CGRect) calculateSize:(NSString *)pInput Label:(UILabel *)pLabel {

    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    CGSize expectedLabelSize = [pInput sizeWithFont:pLabel.font constrainedToSize:maximumLabelSize lineBreakMode:pLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = pLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    
    return newFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Profile";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"reload"] integerValue] == 1) {
        [self loadProfileInfo]; // need to reload the page
        [userDefault setInteger:0 forKey:@"reload"];
    }
    else {
        
    }
    
    [super viewWillAppear:animated];
}

-(IBAction)pressReportHourBtn:(id)sender {
    // move to a report hour page
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Did you provide or receive the service that you want to report?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Provided", @"Received", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    // this is hard-coded
    MTBItem *mItem = [[MTBItem alloc] initToMessage:@"" Eblast:@"" ListMbrID:memID PostNum:0 ProfileImage:@"" TimeStamp:@"" Email:@"" Phone:@"" ListMbrName:username EOLat:0.0 EOLon:0.0 EDLat:0.0 EDLon:0.0 EXDays:14];
    mItem.mSvcID = 1009;
    mItem.mSvcCatID = 1000;
    
    if([title isEqualToString:@"Provided"])
    {
        NSLog(@"Provided");
        MTBReportHoursViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHoursViewController"];
        [viewController setIsProvider:@"T"];
        [viewController setIsReceiver:@"F"];
        [viewController setMItem:mItem];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([title isEqualToString:@"Received"])
    {
        NSLog(@"Received");
        MTBReportHoursViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBReportHoursViewController"];
        [viewController setIsProvider:@"F"];
        [viewController setIsReceiver:@"T"];
        [viewController setMItem:mItem];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([title isEqualToString:@"Logout"])
    {
        // reset NSUserDefaults
        NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
        
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for(int i=0 ; i<[viewControllers count] ; i++){
            
            id obj=[viewControllers objectAtIndex:i];
            
            NSLog(@"%@", [obj class]);
            
            if([obj isKindOfClass:[MTBLoginViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
        
        MTBLoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTBLoginViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(IBAction)pressCreditHistoryBtn:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Credit History"
                                                      message:[NSString stringWithFormat:@"%C Hours spent: %.01fh\n%C Hours earned: 12.0h\n%C Volunteer work received: 2.0h\n%C Volunteer work performed: 2.5h\n%C Gifts received: 2.0h\n%C Gifts donated: 4.0h",
                                                               (unichar) 0x2022,
                                                               [creditProvided floatValue],
                                                               (unichar) 0x2022,
                                                               //[creditReceived floatValue],
                                                               (unichar) 0x2022,
                                                               (unichar) 0x2022,
                                                               (unichar) 0x2022,
                                                               (unichar) 0x2022]
                                                     delegate:nil
                                            cancelButtonTitle:@"Close"
                                            otherButtonTitles:nil, nil];
    [message show];
    
}

-(IBAction)pressLogoutBtn:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message"
                                                      message:@"Proceed to logout?"
                                                     delegate:self
                                            cancelButtonTitle:@"Logout"
                                            otherButtonTitles:@"Cancel", nil];
    [message show];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MTBOffersViewController"]) {
        
        MTBOffersRequestsViewController *viewController = (MTBOffersRequestsViewController *)[segue destinationViewController];
        [viewController setList:offerAry];
    }
    else if ([[segue identifier] isEqualToString: @"MTBRequestsViewController"]) {
        MTBOffersRequestsViewController *viewController = (MTBOffersRequestsViewController *)[segue destinationViewController];
        [viewController setList:requestAry];
    }
    else if ([[segue identifier] isEqualToString: @"MTBProfileEditBioViewController"]) {
        MTBProfileEditBioViewController *viewController = (MTBProfileEditBioViewController *)[segue destinationViewController];
        [viewController setBioDescription:bio];
    }
    else if ([[segue identifier] isEqualToString: @"MTBProfileEditContactViewController"]) {
        MTBProfileEditContactViewController *viewController = (MTBProfileEditContactViewController *)[segue destinationViewController];
        
        NSLog(@"%@ %@ %@ %@", home1, mobile, website, email1);
        
        [viewController setHome1:home1];
        [viewController setMobile:mobile];
        [viewController setWebsite:website];
        [viewController setEmail1:email1];
    }
}

-(IBAction)toggleSwitch:(id)sender {
    if (shareMyLocSwitch.on) {
        [userDefault setBool:YES forKey:@"location"];
    }
    else {
        [userDefault setBool:NO forKey:@"location"];
    }
}

-(IBAction)contactHomeBtnPressed:(id)sender {
    
    NSLog(@"%@", home1);
    home1 = [home1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    home1 = [home1 stringByReplacingOccurrencesOfString:@")" withString:@""];
    home1 = [home1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    home1 = [home1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", home1);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",home1]]];
}

-(IBAction)contactMobileBtnPressed:(id)sender {
    
    NSLog(@"%@", mobile);
    mobile = [mobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", mobile);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",mobile]]];
}

-(IBAction)contactEmailBtnPressed:(id)sender {
    
    NSLog(@"%@", email1);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", email1]]];
}

-(IBAction)contactWebBtnPressed:(id)sender {
    
    NSLog(@"%@", website);
    if ([website rangeOfString:@"http"].location == NSNotFound) {
        website = [NSString stringWithFormat:@"http://%@", website];
    }
    NSLog(@"%@", website);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
}

@end

//
//  SpecialEventItem.m
//  civ_festival
//
//  Created by Keith Kyungsik Han on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTBItem.h"

@implementation MTBItem 

@synthesize mID;
@synthesize mUserID;
@synthesize mUserName;
@synthesize mUserPass;
@synthesize mType;
@synthesize mDescription;
@synthesize mLatitude;
@synthesize mLongitude;
@synthesize mStartDate;
@synthesize mEndDate;
@synthesize mUploadDate;
@synthesize mAmount;
@synthesize mFBUser;
@synthesize mUserImageID;
@synthesize mGroupID;
@synthesize mStatus;
@synthesize mTakenUserID;
@synthesize mTakenUserName;
@synthesize mTakenUserFB;
@synthesize mOtherUserImageID;


@synthesize mExp;
@synthesize mEblast;
@synthesize mProfileImage;
@synthesize mEmail;
@synthesize mPhone;
@synthesize mListMbrName;
@synthesize mTimestamp;

@synthesize mListMbrID;
@synthesize mPostNum;

@synthesize mSvcID;
@synthesize mSvcCatID;
@synthesize mSvcCat;
@synthesize mService;

@synthesize mOLat, mOLon, mDLat, mDLon;

@synthesize xDays;

- (id) initWithValue: (NSInteger)pID UserID:(NSInteger)pUserID UserName:(NSString *)pUserName UserPass:(NSString *)pUserPass Type:(NSString *)pType Description:(NSString*)pDescription Latitude:(NSString*)pLatitude Longitude:(NSString *)pLongitude StartDate:(NSString *)pStartDate EndDate:(NSString *)pEndDate UploadDate:(NSString *)pUploadDate Amount:(NSInteger)pAmount FBUser:(NSInteger)pFBUser UserImageID:(NSInteger)pUserImageID {
    
    mID = pID;
    mUserID = pUserID;
    mUserName = pUserName;
    mUserName = [mUserName stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    
    mUserPass = pUserPass;
    mType = pType;
    mDescription = pDescription;
    mLatitude = pLatitude;
    mLongitude = pLongitude;
    mStartDate = pStartDate;
    mEndDate = pEndDate;
    mUploadDate = pUploadDate;
    mAmount = pAmount;
    mFBUser = pFBUser;
    mUserImageID = pUserImageID;
    
    return self;
}

- (id) initToMessage: (NSString *)pExp Eblast:(NSString *)pEblast ListMbrID:(NSInteger)pListMbrID PostNum:(NSInteger)pPostNum ProfileImage:(NSString *)pProfileImage TimeStamp:(NSString *)pTimeStamp Email:(NSString *)pEmail Phone:(NSString *)pPhone ListMbrName:(NSString *)pListMbrName EOLat:(double)pLatitude1 EOLon:(double)pLongitude1 EDLat:(double)pLatitude2 EDLon:(double)pLongitude2 EXDays:(int)pXDays {
    // remove .. in a profileImage string
    pProfileImage = [pProfileImage stringByReplacingOccurrencesOfString:@".." withString:@""];
    
    
    if ([pEblast isEqual:[NSNull null]]) {
        pEblast = @"";
    }
    else {
        pEblast = [pEblast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        pEblast = [pEblast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        /*
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n\n"];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"</h3>" withString:@""];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"<h3>" withString:@""];
        pEblast = [pEblast stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
        */
    }
    
    if ([pListMbrName isEqual:[NSNull null]]) {
        pListMbrName = @"";
    }
    else {
        pListMbrName = [pListMbrName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }    
    
    mExp = pExp;
    mEblast = pEblast;
    mListMbrID = pListMbrID;
    mPostNum = pPostNum;
    mProfileImage = pProfileImage;
    mTimestamp = pTimeStamp;
    mEmail = pEmail;
    mPhone = pPhone;
    mListMbrName = pListMbrName;
    mListMbrName = [mListMbrName stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    mOLat = pLatitude1;
    mOLon = pLongitude1;
    mDLat = pLatitude2;
    mDLon = pLongitude2;
    
    mSvcCatID = 1009;
    mSvcID = 1000;
    
    xDays = pXDays;
    
    return self;
}

- (id) initToTask: (NSInteger)pListMemID Edescr:(NSString *)pDescr ESvcCat:(NSString *)pSvcCat EMemName:(NSString *) pMemName ESvcCatID:(NSInteger) pSvcCatID ESvcID:(NSInteger)pSvcID EService:(NSString *)pService ETimestamp:(NSString *)pTimestamp EProlfileImage:(NSString *)pProfileImage EOLat:(double)pLatitude1 EOLon:(double)pLongitude1 EDLat:(double)pLatitude2 EDLon:(double)pLongitude2 EXDays:(int)pXDays EEmail1:(NSString *)pEmail1{
    // remove .. in a profileImage string
    pProfileImage = [pProfileImage stringByReplacingOccurrencesOfString:@".." withString:@""];
    
    if ([pMemName isEqual:[NSNull null]]) {
        pMemName = @"";
    }
    else {
        pMemName = [pMemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if ([pDescr isEqual:[NSNull null]]) {
        pDescr = @"";
    }
    else {
        pDescr = [pDescr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        pDescr = [pDescr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        pDescr = [pDescr stringByReplacingOccurrencesOfString:@"<span class='cat'> " withString:@"\n"];
        pDescr = [pDescr stringByReplacingOccurrencesOfString:@" </span>" withString:@""];
    }
    
    mListMbrID = pListMemID;
    mDescription = pDescr;
    mSvcCat = pSvcCat;
    mUserName = pMemName;
    mUserName = [mUserName stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    
    mSvcCatID = pSvcCatID;
    mSvcID = pSvcID;
    mService = pService;
    mTimestamp = pTimestamp;
    mProfileImage = pProfileImage;
    
    mOLat = pLatitude1;
    mOLon = pLongitude1;
    mDLat = pLatitude2;
    mDLon = pLongitude2;

    xDays = pXDays;
    
    mEmail = pEmail1;
    
    return self;
}



@end


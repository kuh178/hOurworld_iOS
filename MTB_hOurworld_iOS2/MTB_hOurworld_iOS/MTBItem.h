//
//  SpecialEventItem.h
//  civ_festival
//
//  Created by Keith Kyungsik Han on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBItem : NSObject {
    NSInteger mID;
    NSInteger mUserID;
    NSString *mUserName;
    NSString *mUserPass;
    NSString *mType;
    NSString *mDescription;
    NSString *mLatitude;
    NSString *mLongitude;
    NSString *mStartDate;
    NSString *mEndDate;
    NSString *mUploadDate;
    NSString *mTakenUserName;
    
    NSString *mExp;
    NSString *mEblast;
    NSString *mProfileImage;
    NSString *mEmail;
    NSString *mPhone;
    NSString *mListMbrName;
    NSString *mTimestamp;

    NSInteger mAmount;
    NSInteger mFBUser;
    NSInteger mUserImageID;
    NSInteger mOtherUserImageID;
    NSInteger mGroupID;
    NSInteger mStatus;
    
    NSInteger mTakenUserID;
    NSString *mTakenUserFB;
    
    NSInteger mListMbrID;
    NSInteger mPostNum;
    
    NSInteger mSvcID;
    NSInteger mSvcCatID;
    NSString *mSvcCat;
    NSString *mService;
    
    double oLat;
    double oLon;
    double dLat;
    double dLon;
    
    int xDays;
}

@property (nonatomic, assign) NSInteger mID;
@property (nonatomic, assign) NSInteger mUserID;

@property (nonatomic, retain) NSString *mUserName;
@property (nonatomic, retain) NSString *mUserPass;
@property (nonatomic, retain) NSString *mType;
@property (nonatomic, retain) NSString *mDescription;
@property (nonatomic, retain) NSString *mLatitude;
@property (nonatomic, retain) NSString *mLongitude;
@property (nonatomic, retain) NSString *mStartDate;
@property (nonatomic, retain) NSString *mEndDate;
@property (nonatomic, retain) NSString *mUploadDate;
@property (nonatomic, retain) NSString *mTakenUserName;
@property (nonatomic, retain) NSString *mTimestamp;

@property (nonatomic, retain) NSString *mExp;
@property (nonatomic, retain) NSString *mEblast;
@property (nonatomic, retain) NSString *mProfileImage;
@property (nonatomic, retain) NSString *mEmail;
@property (nonatomic, retain) NSString *mPhone;
@property (nonatomic, retain) NSString *mListMbrName;

@property (nonatomic, assign) NSInteger mAmount;
@property (nonatomic, assign) NSInteger mFBUser;
@property (nonatomic, assign) NSInteger mUserImageID;
@property (nonatomic, assign) NSInteger mGroupID;
@property (nonatomic, assign) NSInteger mStatus;

@property (nonatomic, assign) NSInteger mTakenUserID;
@property (nonatomic, assign) NSInteger mOtherUserImageID;

@property (nonatomic, retain) NSString *mTakenUserFB;

@property (nonatomic, assign) NSInteger mListMbrID;
@property (nonatomic, assign) NSInteger mPostNum;

@property (nonatomic, assign) NSInteger mSvcID;
@property (nonatomic, assign) NSInteger mSvcCatID;
@property (nonatomic, retain) NSString *mSvcCat;
@property (nonatomic, retain) NSString *mService;

@property (nonatomic, assign) double mOLat;
@property (nonatomic, assign) double mOLon;
@property (nonatomic, assign) double mDLat;
@property (nonatomic, assign) double mDLon;
@property (nonatomic, assign) int xDays;

- (id) initWithValue: (NSInteger)pID UserID:(NSInteger)pUserID UserName:(NSString *)pUserName UserPass:(NSString *)pUserPass Type:(NSString *)pType Description:(NSString*)pDescription Latitude:(NSString*)pLatitude Longitude:(NSString *)pLongitude StartDate:(NSString *)pStartDate EndDate:(NSString *)pEndDate UploadDate:(NSString *)pUploadDate Amount:(NSInteger)pAmount FBUser:(NSInteger)pFBUser UserImageID:(NSInteger)pUserImageID;

- (id) initToMessage: (NSString *)pExp Eblast:(NSString *)pEblast ListMbrID:(NSInteger)pListMbrID PostNum:(NSInteger)pPostNum ProfileImage:(NSString *)pProfileImage TimeStamp:(NSString *)pTimeStamp Email:(NSString *)pEmail Phone:(NSString *)pPhone ListMbrName:(NSString *)pListMbrName EOLat:(double)oLatitude EOLon:(double)oLongitude EDLat:(double)dLatitude EDLon:(double)dLongitude EXDays:(int)pXDays;

- (id) initToTask: (NSInteger)pListMemID Edescr:(NSString *)pDescr ESvcCat:(NSString *)pSvcCat EMemName:(NSString *) pMemName ESvcCatID:(NSInteger) pSvcCatID ESvcID:(NSInteger) pSvcID EService:(NSString *)pService ETimestamp:(NSString *)pTimestamp EProlfileImage:(NSString *)pProfileImage EOLat:(double)oLatitude EOLon:(double)oLongitude EDLat:(double)dLatitude EDLon:(double)dLongitude EXDays:(int)pXDays EEmail1:(NSString *)pEmail1;

@end

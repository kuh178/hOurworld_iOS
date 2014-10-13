//
//  LocationAnnotation.h
//  civ_festival
//
//  Created by Keith Kyungsik Han on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation>{
	CLLocationCoordinate2D coordinate;
	NSString *currentSubTitle;
	NSString *currentTitle;
	int currentID;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *currentSubTitle;
@property (nonatomic, retain) NSString *currentTitle;
@property (assign) int currentID;

- (NSString *)title;
- (NSString *)subtitle;
- (int)getID;
- (id)initWithCoordinate:(CLLocationCoordinate2D)c;

@end

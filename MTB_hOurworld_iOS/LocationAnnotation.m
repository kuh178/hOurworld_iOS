//
//  LocationAnnotation.m
//  civ_festival
//
//  Created by Keith Kyungsik Han on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

@synthesize coordinate;
@synthesize currentSubTitle;
@synthesize currentTitle;
@synthesize currentID;

- (NSString *)subtitle {
	return currentSubTitle;
}

- (NSString *)title {
	return currentTitle;
}

- (int)getID {
	return currentID;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c {
	coordinate = c;
	return self;
}

@end


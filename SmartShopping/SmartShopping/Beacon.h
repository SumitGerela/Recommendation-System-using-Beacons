//
//  Beacon.h
//  SmartShopping
//
//  Created by Sumit Gerela on 4/23/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface Beacon : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (strong, nonatomic) CLBeacon *lastSeenBeacon;

- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;

- (BOOL) isEqualToBeacon: (CLBeacon *) beacon;

@end

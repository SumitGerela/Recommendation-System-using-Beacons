//
//  Beacon.m
//  SmartShopping
//
//  Created by Sumit Gerela on 4/23/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import "Beacon.h"

static NSString * const kUUIDKey = @"uuid";
static NSString * const kMajorValueKey = @"major_id";
static NSString * const kMinorValueKey = @"minor_id";
static NSString * const kProductsKey = @"products";

@implementation Beacon

- (instancetype)initWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor
{
    self = [super init];
    
    if(!self)
    {
        return nil;
    }
    
    _uuid = uuid;
    _majorValue = major;
    _minorValue = minor;
    
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _uuid = [aDecoder decodeObjectForKey:kUUIDKey];
    _majorValue = [[aDecoder decodeObjectForKey:kMajorValueKey] unsignedIntegerValue];
    _minorValue = [[aDecoder decodeObjectForKey:kMinorValueKey] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uuid forKey:kUUIDKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.majorValue] forKey:kMajorValueKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.minorValue] forKey:kMinorValueKey];
    
}

- (BOOL)isEqualToBeacon:(CLBeacon *)beacon {
    if ([[beacon.proximityUUID UUIDString] isEqualToString:[self.uuid UUIDString]] &&
        [beacon.major isEqual: @(self.majorValue)] &&
        [beacon.minor isEqual: @(self.minorValue)])
    {
        return YES;
    } else {
        return NO;
    }
}


@end

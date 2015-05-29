//
//  RecommendationViewController.h
//  SmartShopping
//
//  Created by Sumit Gerela on 4/23/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTWebServiceHandler.h"

@import CoreLocation;

@interface RecommendationViewController : UIViewController <RESTWebServiceHandlerDelegate, CLLocationManagerDelegate, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *beaconsList;

@end

//
//  RecommendationViewController.m
//  SmartShopping
//
//  Created by Sumit Gerela on 4/23/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import "RecommendationViewController.h"
#import "Beacon.h"

static NSString * const kGetBeaconsRestCall = @"beacons/";
static NSString * const kGetRecommendationsCall = @"user/PersonalizedRecommendation/";
static NSString * const kGetTrendingProduct = @"TrendingProducts/";
static NSString * const kGetDiscount = @"discount/";
static NSString * const kUserDefaultBeaconKey = @"beaconList";
static NSString * const kLastSeenBeacon = @"lastSeenBeacon";

@interface RecommendationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendationLabel;
@property (weak, nonatomic) IBOutlet UILabel *trendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (nonatomic, strong) Beacon *lastSeenBeacon;

//UIActivity Indicators

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *trendingActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *recoActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *discountActivity;

- (void) startMonitoringBeacon:(Beacon *) beacon;
- (void) stopMonitoringBeacon:(Beacon *) beacon;
- (void) persistBeaconList;
- (void) loadBeaconList;
- (CLBeaconRegion *) regionWithBeacon:(Beacon *) beacon;

@end

@implementation RecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Start Location logging here.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    RESTWebServiceHandler *handler = [[RESTWebServiceHandler alloc] init];
    handler.delegate = self;
    handler.currentCall = kGetBeaconsRestCall;
    [handler callServerOperationWithRestEndPoint:handler.currentCall andParameters:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods



- (CLBeaconRegion *) regionWithBeacon:(Beacon *) beacon
{
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.uuid major:beacon.majorValue minor:beacon.minorValue identifier:[NSString stringWithFormat:@"Region%hu",beacon.majorValue]];
    return region;
}

- (void) startMonitoringBeacon:(Beacon *) beacon
{
    CLBeaconRegion *region = [self regionWithBeacon:beacon];
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:region];
}

- (void) stopMonitoringBeacon:(Beacon *) beacon
{
    CLBeaconRegion *region = [self regionWithBeacon:beacon];
    [self.locationManager stopMonitoringForRegion:region];
    [self.locationManager stopRangingBeaconsInRegion:region];
}

- (void) persistBeaconList
{
    NSMutableArray *tempBeaconList = [[NSMutableArray alloc] init];
    
    
    for(Beacon *b in self.beaconsList)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:b];
        [tempBeaconList addObject:data];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:tempBeaconList forKey:kUserDefaultBeaconKey];
}

- (void) loadBeaconList
{
    NSArray *storedList = [[NSUserDefaults standardUserDefaults] arrayForKey:kUserDefaultBeaconKey];
    self.beaconsList = [NSMutableArray array];
    
    if(storedList)
    {
        for(NSData *data in storedList)
        {
            Beacon *b = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.beaconsList addObject:b];
            [self startMonitoringBeacon:b];
        }
    }
}

#pragma --

#pragma mark RESTWebServiceHandler Delegate

- (void) serverDidFinishOperation:(NSData *) data ForOpCode:(NSString *)opCode
{
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    
    if([opCode isEqualToString:kGetBeaconsRestCall])
    {
        NSError *error = nil;
        
        self.beaconsList = [[NSMutableArray alloc] init];
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] options:NSJSONReadingMutableContainers error:&error];
        
        if(json != nil)
        {
            //Retrieve beacons
            for(NSDictionary *d in json)
            {
                
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[d objectForKey:@"uuid"]];
                CLBeaconMajorValue majorId = [[d objectForKey:@"major_id"] intValue];
                CLBeaconMinorValue minorId = [[d objectForKey:@"minor_id"] intValue];
                
                Beacon *b = [[Beacon alloc] initWithUUID:uuid major:majorId minor:minorId];
                [self.beaconsList addObject:b];
            }
            
            [self persistBeaconList];
            [self loadBeaconList];
        }
    }
    else if ([opCode isEqualToString:kGetRecommendationsCall])
    {
        [self.recoActivity stopAnimating];
        NSError *error = nil;
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] options:NSJSONReadingMutableContainers error:&error];
        
        if(json != nil && json.count != 0)
        {
            
            NSDictionary *d = [json objectAtIndex:0];
        
            NSString *lhs = [d objectForKey:@"lhs"];
            NSString *rhs = [d objectForKey:@"rhs"];
            self.recommendationLabel.text = [NSString stringWithFormat:@"Hey! Majority of the customers who bought %@ also bought %@. You wanna try?", lhs, rhs];
        }
        
        [self.trendingActivity startAnimating];
        RESTWebServiceHandler *handler = [[RESTWebServiceHandler alloc] init];
        handler.delegate = self;
        handler.currentCall = kGetTrendingProduct;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSString *major = [NSString stringWithFormat:@"%@", self.majorLabel.text];
        NSString *minor = [NSString stringWithFormat:@"%@", self.majorLabel.text];
        
        NSString *parameters = [NSString stringWithFormat:@"%@/%@/%@/%@",userName, pass, major, minor];
        [handler callServerOperationWithRestEndPoint:handler.currentCall andParameters:parameters];
    }
    else if ([opCode isEqualToString:kGetTrendingProduct])
    {
        [self.trendingActivity stopAnimating];
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] options:NSJSONReadingMutableContainers error:&error];
        
        if(json != nil)
        {
            NSString *product = [json objectForKey:@"_id"];
            NSString *count = [json objectForKey:@"value"];
            
            self.trendingLabel.text = [NSString stringWithFormat:@"%@ has been bought %@ times!, You buy it, we trend it!", product, count];
            
        }
        
        [self.discountActivity startAnimating];
        RESTWebServiceHandler *handler = [[RESTWebServiceHandler alloc] init];
        handler.delegate = self;
        handler.currentCall = kGetDiscount;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSString *major = [NSString stringWithFormat:@"%@", self.majorLabel.text];
        NSString *minor = [NSString stringWithFormat:@"%@", self.majorLabel.text];
        
        NSString *parameters = [NSString stringWithFormat:@"%@/%@/%@/%@",userName, pass, major, minor];
        [handler callServerOperationWithRestEndPoint:handler.currentCall andParameters:parameters];
    }
    else if ([opCode isEqualToString:kGetDiscount])
    {
        [self.discountActivity stopAnimating];
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] options:NSJSONReadingMutableContainers error:&error];
        
        if(json != nil)
        {
            NSString *product = [json objectForKey:@"product"];
            NSString *discount = [json objectForKey:@"discount"];
            
            self.discountLabel.text = [NSString stringWithFormat:@"Hurry up! Buy %@ near you and get %@%% discount!", product, discount];
        }
    }
}

-(void) serverDidFailOperation:(NSError *) error ForOpCode:(NSString *)opCode
{
}

#pragma --

#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    
    for (CLBeacon *beacon in beacons){
        for (Beacon *item in self.beaconsList){
            if ([item isEqualToBeacon:beacon] && ![self.majorLabel.text isEqualToString:[NSString stringWithFormat:@"%@", beacon.major]]){
                if(beacon.proximity == CLProximityNear || beacon.proximity == CLProximityImmediate){
                    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
                
                [self.recoActivity startAnimating];
                RESTWebServiceHandler *handler = [[RESTWebServiceHandler alloc] init];
                handler.delegate = self;
                handler.currentCall = kGetRecommendationsCall;
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
                NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
                NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
                
                NSString *parameters = [NSString stringWithFormat:@"%@/%@/%@/%@",userName, pass, major, minor];
                [handler callServerOperationWithRestEndPoint:handler.currentCall andParameters:parameters];
            }
        }
    }
}
}

@end

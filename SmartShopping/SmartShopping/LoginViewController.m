//
//  ViewController.m
//  SmartShopping
//
//  Created by Chien Nguyen on 4/22/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import "LoginViewController.h"
#import "Beacon.h"

static NSString * const kLoginRestCall = @"user/login/";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressLogin:(id)sender
{
    NSString *userId = [self.userField text];
    NSString *userPassword = [self.passwordField text];
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:userPassword forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *parameters = [NSString stringWithFormat:@"%@/%@", userId,userPassword];
    
    RESTWebServiceHandler *handler = [[RESTWebServiceHandler alloc] init];
    handler.delegate = self;
    
    //1. Rest call for login
    [self.activityIndicator startAnimating];
    [self.loginButton setEnabled:NO];
    [handler callServerOperationWithRestEndPoint:kLoginRestCall andParameters:parameters];
    
}


#pragma mark RESTWebServiceHandler Delegate

- (void) serverDidFinishOperation:(NSData *) data ForOpCode:(NSString *)opCode
{
    [self.activityIndicator stopAnimating];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Request Completed = %@", response);
    
    if([response isEqual:@"Success"])
    {
        //Push Recommendation controller here
        [self performSegueWithIdentifier:@"GoToRecommendationView" sender:self];
    }
    else
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials" message:@"You entered invalid user id or password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [errorAlert show];
        [self.loginButton setEnabled:YES];
    }
  
    
}

-(void) serverDidFailOperation:(NSError *) error ForOpCode:(NSString *)opCode
{
    
}

@end

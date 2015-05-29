//
//  ViewController.h
//  SmartShopping
//
//  Created by Chien Nguyen on 4/22/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTWebServiceHandler.h"

@interface LoginViewController : UIViewController <RESTWebServiceHandlerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)didPressLogin:(id)sender;

@end


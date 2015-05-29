//
//  RESTWebServiceHandler.m
//  SmartShopping
//
//  Created by Sumit Gerela on 4/22/15.
//  Copyright (c) 2015 Sumit Gerela. All rights reserved.
//

#import "RESTWebServiceHandler.h"

#define kServerURL @"http://52.8.85.106:8080/"

@implementation RESTWebServiceHandler

- (void) callServerOperationWithRestEndPoint:(NSString *) uri andParameters:(NSString *) parameters
{
    NSString *link = [NSString stringWithFormat:@"%@%@%@",kServerURL, uri, parameters];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:link] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError)
            {
                NSLog(@"HTTP Error = %@ with Code = %d", connectionError.localizedDescription, (int) connectionError.code);
                [self.delegate serverDidFailOperation:connectionError ForOpCode:self.currentCall];
            }
            else
            {
                [self.delegate serverDidFinishOperation:data ForOpCode:self.currentCall];
            }
        });
        
    }];
}

@end

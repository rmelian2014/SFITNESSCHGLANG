//
//  User.m
//  Mytest
//
//  Created by Dimitris Bouzikas on 2/19/14.
//  Copyright (c) 2014 com.bloomarank. All rights reserved.
//

#import "User.h"

@implementation User

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    // Validate user here with your implementation
    // and notify the root controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginActionFinished" object:self userInfo:nil];
}

- (void)logout{
    // Here you can delete the account
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"registered"];
}

- (BOOL)userAuthenticated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL flag = [defaults boolForKey:@"registered"];
    //NSString *sMemCode = [defaults objectForKey:@"txtMemCode"];
    
    NSLog(flag ? @"Yes" : @"No");
    //NSLog(@"MemCode %@",sMemCode);
    
//    BOOL auth = NO;
    
    if ([defaults boolForKey:@"registered"]) {
        return YES; //*** YES go to news page
    }else{
        return NO; //*** Go to register page
    }        
}

@end

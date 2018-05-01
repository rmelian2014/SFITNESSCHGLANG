//
//  User.h
//  Mytest
//
//  Created by Dimitris Bouzikas on 2/19/14.
//  Copyright (c) 2014 com.bloomarank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logout;
- (BOOL)userAuthenticated;

@end

//
//  Upcoming.h
//  SFITNESS
//
//  Created by JASON OOI on 16/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Upcoming : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property(strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSMutableData *responseData;

@end

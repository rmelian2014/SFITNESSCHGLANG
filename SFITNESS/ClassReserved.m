//
//  ClassReserved.m
//  SFITNESS
//
//  Created by BRO on 09/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ClassReserved.h"
#import "AppDelegate.h"

@interface ClassReserved (){
    
    AppDelegate *appDelegate;
    NSString *sRefNo;
    NSString *sURL, *sLanguage;
}

@end

@implementation ClassReserved

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    sRefNo = self.urlString;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/reserve_ticket.asp?"];
    sURL = [sURL stringByAppendingString:@"RefNo="];
    sURL = [sURL stringByAppendingString:sRefNo];
    sURL = [sURL stringByAppendingString:@"&lang="];
    sURL = [sURL stringByAppendingString:sLanguage];
    
    NSLog(@" Load the final URL on WebView : %@ ", sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.tintColor = nil; //=== nil means uses parent tint color, default bule color
}


@end

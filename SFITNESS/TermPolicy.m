//
//  TermPolicy.m
//  SFITNESS
//
//  Created by JASON OOI on 23/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "TermPolicy.h"

@interface TermPolicy (){
    
    NSString *sURL;
}

@end

@implementation TermPolicy
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //--- Set the Navigation Bar to Transparent---
    //UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    //navigationBarAppearance.backgroundColor = [UIColor clearColor];
    //[navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //navigationBarAppearance.shadowImage = [[UIImage alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
}



@end

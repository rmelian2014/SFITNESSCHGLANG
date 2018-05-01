//
//  AboutDet.m
//  SFITNESS
//
//  Created by JASON OOI on 19/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "AboutDet.h"

@interface AboutDet (){
    
    //AppDelegate *appDelegate;
    NSString *sURL;
}

@end

@implementation AboutDet

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //===Make navigation bar transparent and < arrow defaut tint color
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.tintColor = nil; //=== nil means uses parent tint color, default bule color

}

@end

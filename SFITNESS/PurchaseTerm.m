//
//  PurchaseTerm.m
//  SFITNESS
//
//  Created by JASON OOI on 19/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "PurchaseTerm.h"

@interface PurchaseTerm (){
    
    NSString *sURL;
}

@end

@implementation PurchaseTerm

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    [self.navigationItem setHidesBackButton:FALSE];
}

@end

//
//  LoyaltyMail.m
//  SFITNESS
//
//  Created by BRO on 12/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "LoyaltyMail.h"

@interface LoyaltyMail (){
    
    NSString *sURL, *sLanguage;
}

@end

@implementation LoyaltyMail
@synthesize webView;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    //--- Will capture the urlString sent by the previous VC.
    sURL = self.urlString;
    
    NSLog(@"Receive the urlString :%@",sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"忠诚";
        
    }else{
        self.navigationController.navigationBar.topItem.title = @"LOYALTY";
    }
}

@end

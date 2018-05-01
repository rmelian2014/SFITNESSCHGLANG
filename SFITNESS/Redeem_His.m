//
//  Redeem_His.m
//  SFITNESS
//
//  Created by JASON OOI on 16/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Redeem_His.h"

@interface Redeem_His (){
    
    NSString *sURL, *sLanguage;
}
@end

@implementation Redeem_His
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
        
        self.navigationController.navigationBar.topItem.title = @"兑换记录";
        
    }else{
        self.navigationController.navigationBar.topItem.title = @"REDEEM HISTORY";
    }
}

@end

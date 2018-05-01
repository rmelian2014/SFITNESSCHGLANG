//
//  LoyaltyDet.m
//  SFITNESS
//
//  Created by BRO on 12/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "LoyaltyDet.h"
#import "LoyaltyMail.h"

@interface LoyaltyDet (){
    
    NSString *sURL, *sLanguage;
}
@end

@implementation LoyaltyDet

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LoyaltyMail *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"LoyaltyMail"]) {
        
        NSLog(@"Will Pass the urlString :%@",sURL);
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@"What is URL string clicked : %@",theString);
    
    match = [theString rangeOfString: @"loyalty_mail.asp"];
    
    // If the URL string does not contain news_det.asp meaning it will load the webview.
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        //--- Calling this method will tell the segue hey I want to redirect to another viewController.
        //--- Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"LoyaltyMail" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue, and then pass sURL as urlstring to destination VC
    }
    
}

@end


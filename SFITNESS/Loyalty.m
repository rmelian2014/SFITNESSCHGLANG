//
//  Loyalty.m
//  SFITNESS
//
//  Created by BRO on 12/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Loyalty.h"
#import "LoyaltyDet.h"

@interface Loyalty (){
    
    NSString *sURL;
    NSString *sMemCode, *sLanguage;
}

@end

@implementation Loyalty

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //--- Will capture the urlString sent by the previous VC.
    sURL = self.urlString;
    
    NSLog(@"Receive the urlString :%@",sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
  
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"忠诚";
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LoyaltyDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"LoyaltyDet"]) {
        
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    match = [theString rangeOfString: @"loyalty_det.asp"];
    
    // If the URL string does not contain news_det.asp meaning it will load the webview.
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        //--- Calling this method will tell the segue hey I want to redirect to another viewController.
        //--- Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"LoyaltyDet" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue, and then pass sURL as urlstring to destination VC
    }
    
}

@end

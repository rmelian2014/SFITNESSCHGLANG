//
//  Purchase_His.m
//  SFITNESS
//
//  Created by JASON OOI on 16/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Purchase_His.h"
#import "Purchase_HisDet.h"

@interface Purchase_His (){

    NSString *sURL, *sLanguage;
}
@end

@implementation Purchase_His
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
        
        self.navigationController.navigationBar.topItem.title = @"购买记录";
        
    }else{
        self.navigationController.navigationBar.topItem.title = @"PURCHASE HISTORY";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Purchase_HisDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"PurchaseHisDet"]) {
        
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@" What I have clicked %@ " , theString);
    
    match = [theString rangeOfString: @"purchase_det.asp"];
    
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        
        //Calling this method will tell the segue hey I want to redirect to another viewController.
        //Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"PurchaseHisDet" sender:self];
        
        return NO; // Don't load the webview
    }
    
}


@end

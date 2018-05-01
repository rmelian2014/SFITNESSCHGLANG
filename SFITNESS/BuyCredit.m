//
//  BuyCredit.m
//  SFITNESS
//
//  Created by BRO on 05/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "BuyCredit.h"
#import "AppDelegate.h"
#import "PurchaseDet.h"

@interface BuyCredit (){
    
    AppDelegate *appDelegate;
    NSString *sURL;
    NSString *sMemCode, *sLanguage;
}

@end

@implementation BuyCredit

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //sURL = self.urlString;
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/buycredit.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&lang="];
    sURL = [sURL stringByAppendingString:sLanguage];
    
    NSLog(@"Receiving From and the sURL :  %@", sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
}

-(void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    //====Make the navigation Bar appear===
     [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; self.navigationController.navigationBar.shadowImage = nil; self.navigationController.navigationBar.translucent = NO;
    //=== Set the navigation Back < color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"购买钱币";
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.backgroundColor = [UIColor clearColor];
    [navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBarAppearance.shadowImage = [[UIImage alloc] init];
}

- (void)fromClassBook:(NSString*)string {
    
    sURL = string;
    NSLog(@"Please pass over **** %@", sURL);
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PurchaseDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"PurchaseDet"]) {
        
        target.urlString = sURL;
        
    } 
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@"Detect the URL theString :  %@", theString);
    
    match = [theString rangeOfString: @"PHPSMI"];
    
    //--- If the URL string does not contain purchase_det.asp meaning it will load the webview
    if (match.location == NSNotFound) {
        sURL = theString;
        return YES; //--- Load webview
        
    } else {  //--- Because currently the purchase confirm page is just another page, hence will reload the current webview.
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        //--- Calling this method will tell the segue hey I want to redirect to another viewController.
        //--- Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"PurchaseDet" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue, and then pass sURL as urlstring to destination VC
    }
    
}
@end

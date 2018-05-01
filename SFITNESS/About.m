//
//  About.m
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "About.h"
#import "AboutDet.h"

@interface About (){
    
    //AppDelegate *appDelegate;
    NSString *sURL, *sLanguage;
}

@end

@implementation About
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //=== Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //self.navigationController.navigationBar.translucent = NO;
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
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
        
        self.navigationController.navigationBar.topItem.title = @"关于我们";
        
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.backgroundColor = [UIColor clearColor];
    [navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBarAppearance.shadowImage = [[UIImage alloc] init];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AboutDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"AboutDet"]) {
        
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theURLClicked = [URL absoluteString];
    NSRange matchFacebook;
    NSRange matchInstagram;
    NSRange matchTerms;
    NSRange matchPolicy;
    
    NSLog(@" What is the URL clicked %@ " , theURLClicked);
    
    matchFacebook = [theURLClicked rangeOfString: @"facebook"];
    matchInstagram = [theURLClicked rangeOfString: @"instagram"];
    matchTerms = [theURLClicked rangeOfString: @"term.asp"];
    matchPolicy = [theURLClicked rangeOfString: @"policy.asp"];
    
    
    if (matchFacebook.location == NSNotFound && matchInstagram.location == NSNotFound && matchTerms.location == NSNotFound && matchPolicy.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
       // NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        
        //Calling this method will tell the segue hey I want to redirect to another viewController.
        //Update the sURL with the latest String
        sURL = theURLClicked;
        
        [self performSegueWithIdentifier:@"AboutDet" sender:self];
        
        return NO; // Don't load the webview
    }
    
}

@end

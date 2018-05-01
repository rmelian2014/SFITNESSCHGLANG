//
//  PurchaseDet.m
//  SFITNESS
//
//  Created by BRO on 12/03/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "PurchaseDet.h"
#import "MyTabBarController.h"
#import "PurchaseTerm.h"

@interface PurchaseDet (){
    
    NSString *sURL;
}

@end

@implementation PurchaseDet
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

-(void)viewWillAppear:(BOOL)animated {

    //=== Set the navigation Back < color
    self.navigationController.navigationBar.tintColor = nil;
    
    [self.navigationItem setHidesBackButton:TRUE];
   
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:(UIBarButtonSystemItemStop)
                                    target:self
                                    action:@selector(closeButtonTapped:)];
    
    [self.navigationItem setLeftBarButtonItem:closeButton];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

-(void)viewDidDisappear:(BOOL)animated{
}

-(void)closeButtonTapped:(UIButton *)button{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; self.navigationController.navigationBar.shadowImage = nil; self.navigationController.navigationBar.translucent = NO;
    
    //== Go back 2 VC
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController popViewControllerAnimated:YES];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        //[self presentViewController:tabView animated:YES completion:nil];
        
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PurchaseTerm *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"PurchaseTerm"]) {
        
        NSLog(@" To PurchaseTerm sURL  : %@", sURL);
        target.urlString = sURL;
        
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@"Detected the URL Clicked : %@",theString);
    
    match = [theString rangeOfString: @"termsAndConditions.jsp"];
    
    // If the URL string does not contain class_det.asp meaning it is load the webview.
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        sURL = theString;
        [self performSegueWithIdentifier:@"PurchaseTerm" sender:self];
        
        return NO; // Don't load the webview
    }
    
}

@end

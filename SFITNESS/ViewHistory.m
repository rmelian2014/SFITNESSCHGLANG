//
//  ViewHistory.m
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ViewHistory.h"
#import "Reserve_His.h"
#import "Purchase_His.h"
#import "Redeem_His.h"
#import "Statement.h"
#import "Upcoming.h"
#import "Cancel_His.h"

@interface ViewHistory (){
    
    //AppDelegate *appDelegate;
    NSString *sURL;
    NSString *sLanguage;
}

@end

@implementation ViewHistory
@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
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
        
        self.navigationController.navigationBar.topItem.title = @"查看历史";
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Reserve_His *target1 = segue.destinationViewController;
    Purchase_His  *target2 = segue.destinationViewController;
    Redeem_His *target3 = segue.destinationViewController;
    Statement *target4 = segue.destinationViewController;
    Upcoming *target5 = segue.destinationViewController;
    Cancel_His *target6 = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"Reserve_His"]) {
        
        target1.urlString = sURL;
        
    }else if ([segue.identifier isEqualToString:@"Purchase_His"]) {
        
        target2.urlString = sURL;
        
    }else if ([segue.identifier isEqualToString:@"Redeem_His"]) {
        
        target3.urlString = sURL;
    
    }else if ([segue.identifier isEqualToString:@"Statement"]){
        
        target4.urlString = sURL;
        
    }else if ([segue.identifier isEqualToString:@"Upcoming"]){
        
        target5.urlString = sURL;
        
   } else if ([segue.identifier isEqualToString:@"Cancel_His"]){
        
       target6.urlString = sURL;
   }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSLog(@" THe URL string is %@ ",URL);
    
    NSString *theString = [URL absoluteString];
    
    if ([theString rangeOfString:@"reserve_his.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Reserve_His" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue
        
    } else if ([theString rangeOfString:@"purchase_his.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Purchase_His" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    } else if ([theString rangeOfString:@"redeem_his.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Redeem_His" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    } else if ([theString rangeOfString:@"statement.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Statement" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"upcoming.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Upcoming" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"cancel_his.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Cancel_His" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"contact"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Contact" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"about.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at DestinationVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"About" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else {
        return YES; //=== Load current VC webview
    }
    
}


@end


//
//  FirstViewController.m
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "News.h"
#import "NewsDet.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface News(){
    AppDelegate *appDelegate;
    NSString *sURL;
}
@end

@implementation News

@synthesize webView;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //=== Call the stored txtMemCode and txtLang, something like session
    NSString *sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    if([sLanguage isEqualToString:@"CN"]){
        self.title =@"新闻";
    }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/news.asp"];
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //--- Check if user is authenticated, if YES then load this page,
    //--- If not, will direct to RootNavifationControllerID storyboard.
    if(![(AppDelegate*)[[UIApplication sharedApplication] delegate] authenticated]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RootViewController *initView =  (RootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationControllerID"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:initView animated:NO completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)handleRefresh:(UIRefreshControl *)refresh {
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/news.asp"];
    
    NSURL *url = [NSURL URLWithString:sURL];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
   
        NSLog(@"handle REfresh %@", sURL);
    
    [webView loadRequest:urlRequest];
    [refresh endRefreshing];
}

//--- Send the detailed URL when clicked to the destination VC.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NewsDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"NewsDet"]) {
        
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

//--- When a URL is clicked at webView, we want to capture the URL string being clicked. If the string of the URL matches the destination VC. We will pass the URL on prepareForSegue method and load the new URL at a new VC. When the current webView is refreshed, the  following method is also called, if the string does not match we will call viewDidLoad and load the webview.
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    match = [theString rangeOfString: @"news_det.asp"];
    
    // If the URL string does not contain news_det.asp meaning it will load the webview.
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);
        //--- Calling this method will tell the segue hey I want to redirect to another viewController.
        //--- Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"NewsDet" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue, and then pass sURL as urlstring to destination VC
    }
    
    
}

@end

//
//  More.m
//  SFITNESS
//
//  Created by BRO on 01/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "More.h"
#import "AppDelegate.h"
#import "Profile.h"
#import "ScanIn.h"
#import "Loyalty.h"
#import "BuyCredit.h"
#import "ViewHistory.h"
#import "Contact.h"
#import "About.h"

@interface More() {
    
    AppDelegate *appDelegate;
    NSString *sURL, *sRefresh;
    NSString *strResult;
    NSString *sMemCode,*sLanguage;
}

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation More

@synthesize webView;
@synthesize statusBarBackGroundView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //UIApplication *app = [UIApplication sharedApplication];
    //CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    //UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0,-statusBarHeight, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    //statusBarView.backgroundColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar addSubview:statusBarView];
        
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    //if ([sLanguage isEqualToString:@"CN"]){
        
    //    self.title =@"更多";
        
   // }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/more.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&lang="];
    sURL = [sURL stringByAppendingString:sLanguage];
    
    sRefresh = sURL;
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];
    
}

- (void)handleRefresh:(UIRefreshControl *)refresh {
    
    NSURL *url = [NSURL URLWithString:sRefresh];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:urlRequest];
    [refresh endRefreshing];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self handleRefresh:nil];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
    //=== Set the navigation Bar text color
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //self.navigationController.navigationBar.translucent = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Profile *target1 = segue.destinationViewController;
    ScanIn  *target2 = segue.destinationViewController;
    Loyalty *target3 = segue.destinationViewController;
    BuyCredit *target4 = segue.destinationViewController;
    ViewHistory *target5 = segue.destinationViewController;
    About *target8 = segue.destinationViewController;
    
    
    if ([segue.identifier isEqualToString:@"Profile"]) {
        
        target1.urlString = sURL;
        
    } else if ([segue.identifier isEqualToString:@"ScanIn"]) {
        
        target2.urlString = sURL;
    
    } else if ([segue.identifier isEqualToString:@"Loyalty"]) {
        
        target3.urlString = sURL;
    
    } else if ([segue.identifier isEqualToString:@"BuyCredit"]){
        
        target4.urlString = sURL;
        
    } else if ([segue.identifier isEqualToString:@"ViewHistory"]){
        
        target5.urlString = sURL;
        
    } else if ([segue.identifier isEqualToString:@"About"]){
        
        target8.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSLog(@" THe URL string is %@ ",URL);

    NSString *theString = [URL absoluteString];
    
    if ([theString rangeOfString:@"profile"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at ProfileVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Profile" sender:self];
        
        return NO; // Don't load the webview, capture the sURL and trigger NewsDet segue
    
    } else if ([theString rangeOfString:@"checkin"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at ScanINVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"ScanIn" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    } else if ([theString rangeOfString:@"loyalty.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at LoyaltyVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Loyalty" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    } else if ([theString rangeOfString:@"buycredit.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at BuyCreditVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"BuyCredit" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"viewhistory.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at ViewHistoryVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"ViewHistory" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"refer.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at ReferFriendVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"ReferFriend" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"contact"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at ContactVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"Contact" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else if ([theString rangeOfString:@"about.asp"].length > 0){
        
        NSLog(@"Will pass to SEQUE and load the URL at AboutVC :%@",theString);
        
        sURL = theString;
        
        [self performSegueWithIdentifier:@"About" sender:self];
        
        return NO; // Don't load the webview, capture the sURL
        
    }else {
        return YES; //=== Load current VC webview
    }
    
}

@end


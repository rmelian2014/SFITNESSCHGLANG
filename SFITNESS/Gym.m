//
//  Gym.m
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Gym.h"
#import "AppDelegate.h"
#import "GymDet.h"
#import <QuartzCore/QuartzCore.h>

@interface Gym () <UISearchBarDelegate> {

    AppDelegate *appDelegate;
    NSString *sURL, *sRefresh, *sSearchBarRefresh;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *latitude, *longitude;
    NSString *sMemCode,*sLanguage;
}

@end

@implementation Gym

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    latitude = appDelegate.slatitude;
    longitude = appDelegate.slongitude;
    NSLog(@" The longitude : %@ ", longitude);
    
    sURL = appDelegate.gURL;
    sURL = [sURL stringByAppendingString:@"/apps/gym.asp?"];
    sURL = [sURL stringByAppendingString:@"memCode="];
    sURL = [sURL stringByAppendingString:sMemCode];
    sURL = [sURL stringByAppendingString:@"&lat="];
    sURL = [sURL stringByAppendingString:latitude];
    sURL = [sURL stringByAppendingString:@"&long="];
    sURL = [sURL stringByAppendingString:longitude];
    sURL = [sURL stringByAppendingString:@"&lang="];
    sURL = [sURL stringByAppendingString:sLanguage];
    
    //sURL = [sURL stringByAppendingString:@"&lat="];
    //sURL = [sURL stringByAppendingString:latitude];
    //sURL = [sURL stringByAppendingString:@"&long="];
    //sURL = [sURL stringByAppendingString:longitude];
    
    NSLog(@" The sURL to be load for the current page : %@ ", sURL);
    sRefresh = sURL;
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        //self.title =@"健身房";
        [_txtGym setPlaceholder:@"搜索你所在城市的地方" ];
    }
    
    self.txtGym.barStyle = UIBarStyleDefault;
    //Clear the border and make the background transparent
    self.txtGym.backgroundImage = [UIImage new];
    UITextField *searchField = [self.txtGym valueForKey:@"searchField"];
    // To change the searchField background color
    searchField.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self handleRefresh:nil];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)handleRefresh:(UIRefreshControl *)refresh {
    
    //sURL = appDelegate.gURL;
    //sURL = [sURL stringByAppendingString:@"/apps/gym.asp?"];
    //sURL = [sURL stringByAppendingString:@"memCode="];
    //sURL = [sURL stringByAppendingString:sMemCode];
    //sURL = [sURL stringByAppendingString:@"&lat=0.3456"];
    //sURL = [sURL stringByAppendingString:@"&long=5.56677"];
    
    NSURL *url = [NSURL URLWithString:sRefresh];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:urlRequest];
    [refresh endRefreshing];
}

- (void)searchBar:(UISearchBar *)txtGym textDidChange:(NSString *)searchText;{
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    latitude = appDelegate.slatitude;
    longitude = appDelegate.slongitude;
    NSLog(@" The longitude : %@ ", longitude);
    
    sSearchBarRefresh = [sRefresh stringByAppendingString:@"&term="];
    sSearchBarRefresh = [sSearchBarRefresh stringByAppendingString:searchText];
    
    NSURL *url = [NSURL URLWithString:sSearchBarRefresh];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    GymDet *target = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"GymDet"]) {
        
        target.urlString = sURL;
        
    } else {
        
        target.urlString = sURL;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@" Will Pass to next VC %@ " , theString);
    
    match = [theString rangeOfString: @"gym_det.asp"];
    
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSLog(@"Will pass to SEQUE and called the URL :%@",theString);

        //Calling this method will tell the segue hey I want to redirect to another viewController.
        //Update the sURL with the latest String
        sURL = theString;
        
        [self performSegueWithIdentifier:@"GymDet" sender:self];
        
        return NO; // Don't load the webview
    }
    
}

#pragma mark - Search Bar Delegate -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end

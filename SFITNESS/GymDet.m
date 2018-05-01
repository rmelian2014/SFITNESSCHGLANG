//
//  GymDet.m
//  SFITNESS
//
//  Created by BRO on 25/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ClassesDet.h"
#import "GymDet.h"
#import "AppDelegate.h"

@interface GymDet(){
    
    AppDelegate *appDelegate;
    NSString *sURL, *sURLFav;
}

@end

@implementation GymDet

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    //--- Set the Navigation Bar to Transparent---
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.backgroundColor = [UIColor clearColor];
    [navigationBarAppearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navigationBarAppearance.shadowImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    UIButton *heart = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([sURL rangeOfString:@"true"].length > 0)
    {
        [heart setImage:[UIImage imageNamed:@"favorite30px.png"] forState:UIControlStateNormal];
        
    }else{
        
        [heart setImage:[UIImage imageNamed:@"notFavorite30px.png"] forState:UIControlStateNormal];
    }
    
    [heart addTarget:self
              action:@selector(buttonTapped:)
    forControlEvents:UIControlEventTouchUpInside];
    
    heart.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0); //--- Top, Left, Bottom, Right. 10 points from the top, minus 10 points from the bottom, the image will shift down.
    
    //--- Option 1
    UIBarButtonItem *jobsButton =
    [[UIBarButtonItem alloc] initWithCustomView:heart];
    
    self.navigationItem.rightBarButtonItem = jobsButton;

    //--- Option 2
    // self.btnFav = [[UIBarButtonItem alloc] initWithCustomView:heart];
    
    // self.navigationItem.rightBarButtonItem = self.;
    
}

-(void)buttonTapped:(UIButton*)heart
{
    NSLog(@"This is the sURL %@", sURL);
    
    NSString *sSeparator= @"&";
    
    NSRange range = [sURL rangeOfString:@"?"];
    NSInteger position = range.location + range.length;
    NSString *sCutTheFront = [sURL substringToIndex:position-1];
    NSString *sRemaining = [sURL substringFromIndex:position];
    NSLog(@"Cut the front : [%@] ", sCutTheFront);
    NSLog(@"The remains : [%@] ", sRemaining);
    
    range = [sRemaining rangeOfString:sSeparator];
    position = range.location + range.length;
    NSString *sQueryStrfccode = [sRemaining substringToIndex:position-1];
    NSString *sRemaining2 = [sRemaining substringFromIndex:position];
    NSLog(@"The QueryStrfccode : [%@] ", sQueryStrfccode);
    NSLog(@"The remains : [%@] ", sRemaining2);
    
    range = [sRemaining2 rangeOfString:sSeparator];
    position = range.location + range.length;
    NSString *sQueryStrMemCode = [sRemaining2 substringToIndex:position-1];

    NSLog(@"The QueryStrMemCode : [%@] ", sQueryStrMemCode);
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    sURLFav = appDelegate.gURL;
    sURLFav = [sURLFav stringByAppendingString:@"/apps/addFav.asp?"];
    sURLFav = [sURLFav stringByAppendingString:sQueryStrMemCode];
    sURLFav = [sURLFav stringByAppendingString:@"&"];
    sURLFav = [sURLFav stringByAppendingString:sQueryStrfccode];
    
    if( [[heart imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"notFavorite30px.png"]])
        
    {
        
        sURLFav = [sURLFav stringByAppendingString:@"&fav=true"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sURLFav]];
        
        NSLog(@" ********This is the sURL become Favorite : %@ ", sURLFav);
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [heart setImage:[UIImage imageNamed:@"favorite30px.png"] forState:UIControlStateNormal];
        
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0.0
                                     options:0.0
                                  animations:^{
                                      
                                      // Heart expands
                                      [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.10 animations:^{
                                          heart.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                      }];
                                      
                                      // Heart contracts.
                                      [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.25 animations:^{
                                          heart.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
                                      
                                  } completion:nil];
    }
    else
    {
        sURLFav = [sURLFav stringByAppendingString:@"&fav=false"];
        
        NSLog(@" -------This is the sURL become Not Favorite : %@ ", sURLFav);
        
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:sURLFav]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [heart setImage:[UIImage imageNamed:@"notFavorite30px.png"] forState:UIControlStateNormal];
        
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0.0
                                     options:0.0
                                  animations:^{
                                      
                                      // Heart expands
                                      [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.10 animations:^{
                                          heart.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                      }];
                                      
                                      // Heart contracts.
                                      [UIView addKeyframeWithRelativeStartTime:0.15 relativeDuration:0.25 animations:^{
                                          heart.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
                                      
                                  } completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ClassesDet *target = segue.destinationViewController;

    
    if ([segue.identifier isEqualToString:@"GymDetToClassesDet"]) {
        
        NSLog(@" To ClassesDet sURL  : %@", sURL);
        target.urlString = sURL;
        
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    //NSRange match;
    
    NSLog(@"Detected the URL Clicked : %@",theString);
    
    //match = [theString rangeOfString: @"class_det.asp"];
    
    
    if ([theString rangeOfString:@"class_det.asp"].length > 0){
        
        sURL = theString;
        
        NSLog(@"Trigger the following SEQUE and pass the sURL :%@",sURL);
        //Calling the following method will trigger the segue and redirect to another viewController.
        [self performSegueWithIdentifier:@"GymDetToClassesDet" sender:self];
        
        return NO; // Don't load the webview
        
    } else if ([theString rangeOfString:@"google.com"].length > 0){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theString]];
        
        return NO; // Don't load the webview, capture the sURL
        
    } else{
        
         return YES; //Load webview
    }
    
    
}

@end


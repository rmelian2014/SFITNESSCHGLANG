//
//  ClassBook.m
//  SFITNESS
//
//  Created by BRO on 24/01/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ClassBook.h"
#import "AppDelegate.h"
#import "BuyCredit.h"
#import "ClassReserved.h"

@interface ClassBook (){
    
    AppDelegate *appDelegate;
    NSString *sURL, *sURLRefresh;
    NSString *strResult;
    NSString *sMemCode;
    NSString *sRefNo;
}

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ClassBook

@synthesize webView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sURL = self.urlString; //--- Receiving from ClassesDet target.urlString
    sURLRefresh = self.urlString; //----Will always use this to refresh.
    NSLog(@" Receiving from ClassesDet the sURL : %@", sURL);
    
    //---Simply load the page
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [webView.scrollView addSubview:refreshControl];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [self handleRefresh:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.tintColor = nil; //=== nil means uses parent tint color, default bule color
}

- (void)handleRefresh:(UIRefreshControl *)refresh {
    
    NSLog(@" HANDLE REFRESH sURLRefresh : %@ ", sURLRefresh);
    
    NSURL *url = [NSURL URLWithString:sURLRefresh];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [refresh endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BuyCredit *target = segue.destinationViewController;
    ClassReserved *target2 = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ClassBuyCredit"]) { //---New Seague that connects ClassBook to BuyCredit VC
        
        
        
        
        
    } else {
        
        NSLog(@" Else to ClassReserved VC and pass the sRefNo : %@", sRefNo);
        target2.urlString = sRefNo;
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    
    if ([theString rangeOfString:@"buycredit.asp"].length > 0){
        
        sURL = theString;
        NSLog(@"Trigger BuyCredit Segue and pass together with this sURL : %@ ",sURL);
        
        //--- Calling the following method will trigger the segue and redirect to another viewController.
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        //[self.navigationController.navigationBar setBarTintColor : [ UIColor grayColor]];
        //=== Set the navigation Bar text color
        //[self.navigationController.navigationBar
        // setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        //self.navigationController.navigationBar.translucent = NO;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"BuyCredit"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [[self navigationController] pushViewController:vc animated:YES];
        
        UINavigationController* classesNav = (UINavigationController*)self.tabBarController.viewControllers[4];
        BuyCredit *classesViewController = [classesNav.viewControllers firstObject];
        [classesViewController fromClassBook:sURL];
        
        return NO; //--- Don't load the current webview
        
    } else if ([theString rangeOfString:@"reservedialog.asp"].length > 0){
        
        sURL = theString;
        
        self.responseData = [NSMutableData data];

        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:sURL]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        NSLog(@" The URL will be loaded on this current VC : %@ ", sURL);
        
        return NO; //--- Don't load the current webview
        
    } else {
        return YES;
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    //[spinner stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    strResult = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"This is the return stuff %@", strResult);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [strResult rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sConfirm = [strResult substringToIndex:position-1];
    NSString *sRemaining = [strResult substringFromIndex:position];
    NSLog(@"The confirm : [%@] ", sConfirm);
    NSLog(@"The remains : [%@] ", sRemaining);
    
    range = [sRemaining rangeOfString:sSeparator];
    position = range.location + range.length;
    NSString *sNotice = [sRemaining substringToIndex:position-1];
    NSString *sRemaining2 = [sRemaining substringFromIndex:position];
    NSLog(@"The end Notice : [%@] ", sNotice);
    NSLog(@"The remaining2 : [%@] ", sRemaining2);
    
    range = [sRemaining2 rangeOfString:sSeparator];
    position = range.location + range.length;
    NSString *sMessage = [sRemaining2 substringToIndex:position-1];
    sRefNo = [sRemaining2 substringFromIndex:position];
    NSLog(@"The sMessage : [%@] ", sMessage);
    NSLog(@"The sRefno : [%@] ", sRefNo);
    
    if ([sConfirm isEqualToString:@"OK"]) {
        
        UIAlertController *alert; alert = [UIAlertController alertControllerWithTitle:sNotice message: sMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok; ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
          {
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"ClassReserved" sender:self];
            
        }];
        
        //*** For the modal ***
        [alert addAction:ok ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end


//
//  Reserve_His.m
//  SFITNESS
//
//  Created by JASON OOI on 16/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "Reserve_His.h"

@interface Reserve_His (){
    
    NSString *sURL, *strResult, *sRemaining;
    NSString *sLanguage;
}

@end

@implementation Reserve_His
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
    
    //=== Initialize the responseData Mutable Data
    self.responseData = [NSMutableData data];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        self.navigationController.navigationBar.topItem.title = @"预定记录";
        
    }else{
        self.navigationController.navigationBar.topItem.title = @"RESERVATION HISTORY";
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *URL = [request URL];
    NSString *theString = [URL absoluteString];
    NSRange match;
    
    NSLog(@"What is URL string clicked : %@",theString);
    
    match = [theString rangeOfString: @"cancelbook.asp"];
    
    if (match.location == NSNotFound) {
        
        return YES; //Load webview
        
    } else {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theString]];
        
        (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        return NO;
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
    NSLog(@"This returned response.write stuff %@", strResult);
    
    NSString *sSeparator= @"|";
    
    NSRange range = [strResult rangeOfString:sSeparator];
    NSInteger position = range.location + range.length;
    NSString *sWhat = [strResult substringToIndex:position-1];
    sRemaining = [strResult substringFromIndex:position];
    
    NSLog(@"This is sLoop %@", sWhat);
    NSLog(@"This is sRemaining %@", sRemaining);
    
    if ([sWhat isEqualToString:@"ERR"]){
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"Error!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             //=== Go back one VC
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
                
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"OK!" message:sRemaining preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancel; cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             //=== Go back one VC
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
        
        [alert addAction:cancel ];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
   
}

@end

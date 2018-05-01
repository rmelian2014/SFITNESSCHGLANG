//
//  GoogleMap.m
//  SFITNESS
//
//  Created by JASON OOI on 25/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "GoogleMap.h"

@interface GoogleMap (){
    
    NSString *sURL;
}

@end

@implementation GoogleMap
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sURL = self.urlString;
    
    NSURL *url = [NSURL URLWithString:sURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView setDelegate:(id<UIWebViewDelegate>)self];
    [webView loadRequest:urlRequest];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
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

-(void)closeButtonTapped:(UIButton *)button{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; self.navigationController.navigationBar.shadowImage = nil; self.navigationController.navigationBar.translucent = NO;
    
    //== Go back 1 VC
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
    
}

@end

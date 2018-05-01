//
//  LogOut.m
//  SFITNESS
//
//  Created by BRO on 02/02/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "LogOut.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface LogOut() {
    
    AppDelegate *appDelegate;
    NSString *sURL;
}

@end

@implementation LogOut

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutAction:(id)sender {
    User *userObj = [[User alloc] init];
    [userObj logout];
    
    //AppDelegate *authObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //authObj.authenticated = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RootViewController *initView =  (RootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationControllerID"];
    [initView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:initView animated:NO completion:nil];
    
}

@end

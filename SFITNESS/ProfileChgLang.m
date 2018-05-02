//
//  ProfileChgLang.m
//  SFITNESS
//
//  Created by JASON OOI on 19/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ProfileChgLang.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface ProfileChgLang (){
    
    AppDelegate *appDelegate;
    NSString *sLanguage;
}

@end

@implementation ProfileChgLang

@synthesize btnEnglish,btnChinese;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //=== Customize the btn
    btnEnglish.layer.cornerRadius =7.0f;
    btnEnglish.layer.shadowRadius = 3.0f;
    btnEnglish.layer.shadowColor = [UIColor blackColor].CGColor;
    btnEnglish.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnEnglish.layer.shadowOpacity = 0.5f;
    btnEnglish.layer.masksToBounds = NO;
    
    //=== Customize the btn
    btnChinese.layer.cornerRadius =7.0f;
    btnChinese.layer.shadowRadius = 3.0f;
    btnChinese.layer.shadowColor = [UIColor blackColor].CGColor;
    btnChinese.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    btnChinese.layer.shadowOpacity = 0.5f;
    btnChinese.layer.masksToBounds = NO;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //--- Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
}

-(void)viewDidAppear:(BOOL)animated{
	//using new code for internationalization
	self.navigationController.navigationBar.topItem.title = [AppDelegate getLocalizedText:@"CHANGE LANGUAGE"];
}

- (IBAction)btnEnglish:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"EN" forKey:@"txtLanguage"];
	
	[(AppDelegate*)[UIApplication sharedApplication].delegate setupTabBar];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnChinese:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"CN" forKey:@"txtLanguage"];
    
    //UITabBarController * tabBarController = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    //[self presentViewController:tabBarController animated:YES completion:nil];
    
    [(AppDelegate*)[UIApplication sharedApplication].delegate setupTabBar];
	[self.navigationController popViewControllerAnimated:YES];
}
@end

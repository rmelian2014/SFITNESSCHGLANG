//
//  ReferFriend.m
//  SFITNESS
//
//  Created by JASON OOI on 13/04/2018.
//  Copyright © 2018 my.com.bro. All rights reserved.
//

#import "ReferFriend.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

@interface ReferFriend (){
    
    AppDelegate *appDelegate;
    NSString *sMessage;
    NSString *sMemCode, *sLanguage;
    NSString *sCutMemCode, *sReferCode;
}

@end

@implementation ReferFriend

@synthesize lblInvite;
@synthesize lblWhatsApp;
@synthesize lblSMS;
@synthesize lblEmail;
@synthesize lblLink;
@synthesize lblReferral;


- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    //=== Call the stored txtMemCode, something like session ---
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sMemCode = [defaults objectForKey:@"txtMemCode"];
    sLanguage = [defaults objectForKey:@"txtLanguage"];
    
    if ([sLanguage isEqualToString:@"CN"]){
        
        lblInvite.text = @"邀请你的朋友一起加入你";
        lblWhatsApp.text = @"通过whatsapp发送给你的朋友";
        lblSMS.text = @"通过信息发送给你的朋友";
        lblEmail.text = @"通过邮件发送给你的朋友";
        lblLink.text = @"复制链接";
        
        sReferCode = @"您的推荐代码 : 88";
        
    }else{
        
        sReferCode = @"Your Referral Code : 88";
        
    }
    sCutMemCode = [sMemCode substringFromIndex:2];
    sReferCode = [sReferCode stringByAppendingString:sCutMemCode];
    sReferCode = [sReferCode stringByAppendingString:@"9"];
    
    lblReferral.text = sReferCode;
    
    sMessage = @"Join me at SHARE FITNESS! My Referral Code: ";
    sMessage = [sMessage stringByAppendingString:sReferCode];
    sMessage = [sMessage stringByAppendingString:@" Visit us at https://www.share-fitness.com/"];
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
        
        self.navigationController.navigationBar.topItem.title = @"介绍朋友";
        
    }
}

- (IBAction)btnWhatsApp:(id)sender {
    
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    sMessage = [sMessage stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",sMessage];
    NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp" message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)btnSMS:(id)sender {
    
    MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
    composeVC.messageComposeDelegate = self;
    
    if([MFMessageComposeViewController canSendText]){
        // Configure the fields of the interface.
        composeVC.recipients = @[@""];
        sMessage = [sMessage stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        composeVC.body = sMessage;
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
        
    }else{
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    // Check the result or perform other tasks.    // Dismiss the message compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnEmail:(id)sender {

    //check mail service is configure to your device or not.
    if ([MFMailComposeViewController canSendMail]) {
        
        // get a new new MailComposeViewController object
        MFMailComposeViewController * composeVC = [MFMailComposeViewController new];
        
        // his class should be the delegate of the composeVC
        composeVC.mailComposeDelegate = self;
        
        // set a mail subject ... but you do not need to do this :)
        [composeVC setSubject:@"Join us at Share Fitness!"];
        
        // set some basic plain text as the message body ... but you do not need to do this :)
        [composeVC setMessageBody:sMessage isHTML:NO];
        
        // set some recipients ... but you do not need to do this :)
        //[composeVC setToRecipients:[NSArray arrayWithObjects:@"first.address@test.com", @"second.address@test.com", nil]];
        
        // Present the view controller modally.
        
        [self presentViewController:composeVC animated:true completion:nil];
    } else {
        
        NSLog(@"Mail services are not available or configure to your device");
        
        UIAlertController * alert; alert = [UIAlertController alertControllerWithTitle:@"ERROR!" message:@"Mail services are not available or configure to your device" preferredStyle:UIAlertControllerStyleAlert];
        
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

// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Send Succesfully"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
            
        default:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    // Dismiss the mail compose view controller.
    [controller dismissViewControllerAnimated:YES completion:nil];
    objc_removeAssociatedObjects(controller);
    
}

- (IBAction)btnLink:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"https://www.share-fiteness.com/";
    
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Link Copied" message:@"The URL https://www.share-fiteness.com/ has been copied to your clipboard "
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
@end
